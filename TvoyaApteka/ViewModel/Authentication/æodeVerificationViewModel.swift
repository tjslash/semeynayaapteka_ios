//
//  СodeVerificationViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol СodeVerificationViewModelDelegate: class {
    func codeVerificationSuccess(user: AuthUserType)
}

class СodeVerificationViewModel {
    
    // MARK: Input
    let smsCode = Variable<String>("")
    let confirmButtonDidTap = PublishSubject<Void>()
    
    // MARK: Output
    let confirmButtonIsEnable: Driver<Bool>
    let registrationError = PublishSubject<String>()
    let smsCodeError = PublishSubject<String?>()
    
    // MARK: Public
    weak var delegate: СodeVerificationViewModelDelegate?
    
    // MARK: Private
    private let favoriteRepository: FavoriteStorageProtocol
    private let passwordContainer: PasswordContainer
    private let errorFabric = ErrorMessageFabric()
    private let isLoading = ActivityIndicator()
    private let authManager: AuthManager
    private let bag = DisposeBag()
    
    init(passwordContainer: PasswordContainer, authManager: AuthManager, favoriteRepository: FavoriteStorageProtocol) {
        self.passwordContainer = passwordContainer
        self.authManager = authManager
        self.favoriteRepository = favoriteRepository
        
        confirmButtonIsEnable = isLoading
            .asDriver()
            .map({ !$0 })
        
        confirmButtonDidTap
            .bind(onNext: { [unowned self] _ in
                self.smsCodeError.onNext(nil)
                self.registerUser()
            })
            .disposed(by: bag)
    }
    
    func registerUser() {
        var authUser: AuthUserType?
        
        authManager.register(phone: passwordContainer.phone,
                             password: passwordContainer.password,
                             passwordConfirm: passwordContainer.passwordConfirm,
                             smsCode: smsCode.value)
            .trackActivity(isLoading)
            .asSingle()
            .flatMapCompletable({ currentUser in
                authUser = currentUser
                
                return currentUser.getToken()
                    .flatMapCompletable({ [unowned self] token in
                        self.sendLocalFavorite(token: token)
                    })
            })
            .subscribe(onCompleted: { [unowned self] in
                self.delegate?.codeVerificationSuccess(user: authUser!)
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

    func sendTheCode() {
        authManager.requestSms(phone: passwordContainer.phone)
            .subscribe()
            .disposed(by: bag)
    }
    
    private func handleError(_ error: Error) {
        guard let serviceError = error as? ServiceError else {
            showErrorMessage(error)
            return
        }
        
        switch serviceError {
        case let .validation(bagErrors):
            if let textError = bagErrors[.smsCode].firstMessage {
                smsCodeError.onNext(textError)
            }
        default:
            showErrorMessage(error)
        }
    }
    
    private func showErrorMessage(_ error: Error) {
        if let message = errorFabric.getMessage(form: error) {
            registrationError.onNext(message)
        }
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
