//
//  LoginViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelDelegate: class {
    func didTapForgotButton()
    func didTapRegistration()
    func loginSuccess(user: AuthUserType)
}

class LoginViewModel {
    
    // MARK: Input
    let phone = Variable<String>("")
    let password = Variable<String>("")
    let loginButtonDidTap = PublishSubject<Void>()
    let forgotButtonDidTap = PublishSubject<Void>()
    let registrationButtonDidTap = PublishSubject<Void>()
    
    // MARK: Output
    let loginButtonIsEnable: Driver<Bool>
    let loginError = PublishSubject<String>()
    let phoneError = PublishSubject<String?>()
    let passwordError = PublishSubject<String?>()
    
    // MARK: Public
    weak var delegate: LoginViewModelDelegate?
    
    // MARK: Private
    private let favoriteRepository: FavoriteStorageProtocol
    private let isLogining = ActivityIndicator()
    private let errorFabric = ErrorMessageFabric()
    private let authManager: AuthManager
    private let bag = DisposeBag()
    
    init(authManager: AuthManager, favoriteRepository: FavoriteStorageProtocol) {
        self.authManager = authManager
        self.favoriteRepository = favoriteRepository
        
        let isValidForm = Driver
            .combineLatest(phone.asDriver(), password.asDriver()) { phone, password -> Bool in
                return !phone.isEmpty && !password.isEmpty
            }
        
        loginButtonIsEnable = Driver
            .combineLatest(isLogining, isValidForm) { isLogining, isValid -> Bool in
                return isLogining == false && isValid == true
            }
        
        loginButtonDidTap
            .withLatestFrom(isValidForm)
            .filter({ $0 == true })
            .subscribe(onNext: { [unowned self] _ in
                self.clearErrors()
                self.login()
            })
            .disposed(by: bag)
        
        forgotButtonDidTap
            .bind(onNext: { [unowned self] _ in
                self.delegate?.didTapForgotButton()
            })
            .disposed(by: bag)
        
        registrationButtonDidTap
            .bind(onNext: { [unowned self] _ in
                self.delegate?.didTapRegistration()
            })
            .disposed(by: bag)
    }
    
    private func login() {
        var authUser: AuthUserType?
        
        authManager.login(phone: phone.value, password: password.value)
            .trackActivity(isLogining)
            .asSingle()
            .flatMapCompletable({ currentUser in
                authUser = currentUser
                
                return currentUser.getToken()
                    .flatMapCompletable({ [unowned self] token in
                        self.sendLocalFavorite(token: token)
                    })
            })
            .subscribe(onCompleted: { [unowned self] in
                self.delegate?.loginSuccess(user: authUser!)
            }, onError: { [unowned self] error in
                self.handleError(error)
            })
            .disposed(by: bag)
    }
    
    private func sendLocalFavorite(token: String) -> Completable {
        let drugIdArray = favoriteRepository.getAll()
        
        guard !drugIdArray.isEmpty else {
            return Completable.empty()
        }
        
        return Observable.from(drugIdArray)
            .flatMap { ServerAPI.favorite.addToFavorite(token: token, drugId: $0) }
            .toArray()
            .ignoreElements()
            .do(onCompleted: { [unowned self] in
                self.favoriteRepository.deleteAll()
            })
    }
    
    private func clearErrors() {
        phoneError.onNext(nil)
        passwordError.onNext(nil)
    }
    
    private func handleError(_ error: Error) {
        guard let serviceError = error as? ServiceError else {
            showErrorMessage(error)
            return
        }
        
        switch serviceError {
        case .validation(let bagError):
            if let textError = bagError[.phone].firstMessage {
                self.phoneError.onNext(textError)
            }
            if let textError = bagError[.password].firstMessage {
                self.passwordError.onNext(textError)
            }
        default:
            showErrorMessage(error)
        }
    }
    
    private func showErrorMessage(_ error: Error) {
        if let message = errorFabric.getMessage(form: error) {
            loginError.onNext(message)
        }
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
