//
//  ChangePasswordViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChangePasswordViewModelDelegate: class {
    func changedPasswordSuccess()
}

class ChangePasswordViewModel {
    
    // MARK: Input
    let smsCode = Variable<String>("")
    let newPassword = Variable<String>("")
    let repeatedPassword = Variable<String>("")
    let restoreButtonDidTap = PublishSubject<Void>()
    
    // MARK: Output
    let restoreButtonisEnable: Driver<Bool>
    let changePasswordSuccess = PublishSubject<Void>()
    let changePasswordError = PublishSubject<String>()
    let sendSmsCodeError = PublishSubject<String>()
    let smsCodeError = PublishSubject<String?>()
    let newPasswordError = PublishSubject<String?>()
    let repeatedPasswordError = PublishSubject<String?>()
    
    // MARK: Public
    weak var delegate: ChangePasswordViewModelDelegate?
    
    // MARK: Private
    private let errorFabric = ErrorMessageFabric()
    private let isLoading = ActivityIndicator()
    private let phone: String
    private let authManager: AuthManager
    private let bag = DisposeBag()
    
    init(phone: String, authManager: AuthManager) {
        self.phone = phone
        self.authManager = authManager
        
        let isValidForm = Driver
            .combineLatest(smsCode.asDriver(), newPassword.asDriver(), repeatedPassword.asDriver())
            { smsCode, newPassword, repeatedPassword -> Bool in
                return !smsCode.isEmpty && !newPassword.isEmpty && !repeatedPassword.isEmpty
            }
        
        restoreButtonisEnable = Driver
            .combineLatest(isLoading, isValidForm) { isLoading, isValid -> Bool in
                return isLoading == false && isValid == true
        }
        
        restoreButtonDidTap
            .withLatestFrom(isValidForm)
            .filter({ $0 == true })
            .bind(onNext: { [unowned self] _ in
                self.clearAllErrors()
                
                if self.isPasswordsEquals() {
                    self.changePassword()
                    return
                }
                
                self.newPasswordError.onNext("Пароли не совпадают")
                self.repeatedPasswordError.onNext("Пароли не совпадают")
            })
            .disposed(by: bag)
    }
    
    func sendSMSCode() {
        authManager.requestSms(phone: phone)
            .subscribe(onError: { [unowned self] error in
                self.showErrorMessage(error)
            })
            .disposed(by: bag)
    }
    
    func passToDelegateSuccess() {
        delegate?.changedPasswordSuccess()
    }
    
    private func changePassword() {
        authManager.restorePassword(phone: phone,
                                           password: newPassword.value,
                                           passwordConfirm: repeatedPassword.value,
                                           smsCode: smsCode.value)
            .trackActivity(isLoading)
            .asCompletable()
            .subscribe(
                onCompleted: { [unowned self] in
                    self.changePasswordSuccess.onNext(())
                },
                onError: { [unowned self] error in
                    self.showErrorMessage(error)
            })
            .disposed(by: bag)
    }
    
    private func handleError(_ error: Error) {
        guard let serviceError = error as? ServiceError else {
            showErrorMessage(error)
            return
        }
        
        switch serviceError {
        case let .validation(bagError):
            if let textError = bagError[.smsCode].firstMessage {
                smsCodeError.onNext(textError)
            }
            if let textError = bagError[.password].firstMessage {
                newPasswordError.onNext(textError)
            }
        default:
            showErrorMessage(error)
        }
    }
    
    private func clearAllErrors() {
        smsCodeError.onNext(nil)
        newPasswordError.onNext(nil)
        repeatedPasswordError.onNext(nil)
    }
    
    private func showErrorMessage(_ error: Error) {
        if let message = errorFabric.getMessage(form: error) {
            changePasswordError.onNext(message)
        }
    }
    
    private func isPasswordsEquals() -> Bool {
        return newPassword.value == repeatedPassword.value
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
