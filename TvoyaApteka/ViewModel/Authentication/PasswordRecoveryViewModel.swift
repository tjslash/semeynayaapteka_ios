//
//  PasswordRecoveryViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PasswordRecoveryViewModelDelegate: class {
    func sendSMS(phone: String)
}

class PasswordRecoveryViewModel {
    
    // MARK: Input
    let phone = Variable<String>("")
    let sendSmsButtonDidTap = PublishSubject<Void>()
    
    // MARK: Output
    let sendSmsButtonIsEnable: Driver<Bool>
    let sendSmsError = PublishSubject<String>()
    let phoneError = PublishSubject<String?>()
    
    // MARK: Public
    weak var delegate: PasswordRecoveryViewModelDelegate?
    
    // MARK: Private
    private let errorFabric = ErrorMessageFabric()
    private let isLoading = ActivityIndicator()
    private let authManager: AuthManager
    private let bag = DisposeBag()
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        
        let isValidForm = phone
            .asDriver()
            .map({ $0.isEmpty == false })
        
        sendSmsButtonIsEnable = Driver
            .combineLatest(isLoading, isValidForm) { isLoading, isValid -> Bool in
                return isLoading == false && isValid == true
            }
        
        sendSmsButtonDidTap
            .withLatestFrom(isValidForm)
            .filter({ $0 == true })
            .bind(onNext: { [unowned self] _ in
                self.phoneError.onNext(nil)
                self.sendSmsCode()
            })
            .disposed(by: bag)
    }
    
    private func sendSmsCode() {
        authManager.requestSms(phone: phone.value)
            .trackActivity(isLoading)
            .asCompletable()
            .subscribe(
                onCompleted: { [unowned self] in
                    self.delegate?.sendSMS(phone: self.phone.value)
                },
                onError: { [unowned self] error in
                    self.handleError(error)
            }).disposed(by: bag)
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
        default:
            showErrorMessage(error)
        }
    }
    
    private func showErrorMessage(_ error: Error) {
        if let message = errorFabric.getMessage(form: error) {
            sendSmsError.onNext(message)
        }
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
