//
//  RegistrationViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RegistrationViewModelDelegate: class {
    func sendSms(passwordContainer: PasswordContainer)
}

class RegistrationViewModel {
    
    // MARK: Input
    let phone = Variable<String>("")
    let password = Variable<String>("")
    let passwordRepeat = Variable<String>("")
    let registrationButtonDidTap = PublishSubject<Void>()
    
    // MARK: Output
    let registrationButtonIsEnable: Driver<Bool>
    let registrationError = PublishSubject<String>()
    let phoneError = PublishSubject<String?>()
    let passwordError = PublishSubject<String?>()
    let passwordRepeatError = PublishSubject<String?>()
    
    // MARK: Public
    weak var delegate: RegistrationViewModelDelegate?
    
    // MARK: Private
    private let errorFabric = ErrorMessageFabric()
    private let isRegistrationProcess = ActivityIndicator()
    private let authManager: AuthManager
    private let bag = DisposeBag()
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        
        let isValidForm = Driver
            .combineLatest(phone.asDriver(), password.asDriver(), passwordRepeat.asDriver()) { phone, password, passwordRepeat -> Bool in
                return !phone.isEmpty && !password.isEmpty && !passwordRepeat.isEmpty
            }
        
        registrationButtonIsEnable = Driver
            .combineLatest(isRegistrationProcess, isValidForm) { isRegistrationProcess, isValid -> Bool in
                return isRegistrationProcess == false && isValid == true
        }
        
        registrationButtonDidTap
            .withLatestFrom(isValidForm)
            .filter({ $0 == true})
            .bind(onNext: { [unowned self] _ in
                self.registrationHandler()
            })
            .disposed(by: bag)
    }
    
    private func registrationHandler() {
        if self.isValidInput() {
            clearAllError()
            registration()
        } else {
            passwordError.onNext("Пароли не совпадают")
            passwordRepeatError.onNext("Пароли не совпадают")
        }
    }
    
    private func registration() {
        authManager.validateUserInfo(phone: phone.value, password: password.value, passwordConfirm: passwordRepeat.value)
            .trackActivity(isRegistrationProcess)
            .asCompletable()
            .subscribe(
                onCompleted: { [unowned self] in
                    self.passDataToDelegate()
                }, onError: { [unowned self] error in
                    self.handleError(error)
            }).disposed(by: bag)
    }
    
    private func handleError(_ error: Error) {
        guard let serviceError = error as? ServiceError else {
            showErrorMessage(error)
            return
        }
        
        switch serviceError {
        case let .validation(bagError):
            if let errorText = bagError[.phone].firstMessage {
                self.phoneError.onNext(errorText)
            }
            if let errorText = bagError[.password].firstMessage {
                self.passwordError.onNext(errorText)
            }
            
        case let .serverError(bagError):
            if let textError = bagError[.server].firstMessage {
                if textError == "Код уже выслан" {
                    passDataToDelegate()
                } else {
                    showErrorMessage(error)
                }
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
    
    private func passDataToDelegate() {
        let passContainer = self.makePasswordContainer()
        delegate?.sendSms(passwordContainer: passContainer)
    }
    
    private func clearAllError() {
        phoneError.onNext(nil)
        passwordError.onNext(nil)
        passwordRepeatError.onNext(nil)
    }
    
    private func isValidInput() -> Bool {
        return password.value == passwordRepeat.value
    }
    
    private func makePasswordContainer() -> PasswordContainer {
        return PasswordContainer(phone: phone.value, password: password.value, passwordConfirm: passwordRepeat.value)
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
