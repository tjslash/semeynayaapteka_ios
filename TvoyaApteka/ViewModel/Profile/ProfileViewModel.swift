//
//  ProfileViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 31.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProfileViewModelDelegate: class {
    func userLogOut()
}

class ProfileViewModel {
    
    public weak var delegate: ProfileViewModelDelegate?
    
    // MARK: Input
    let firstName = Variable<String?>(nil)
    let lastName = Variable<String?>(nil)
    let middleName = Variable<String?>(nil)
    let email = Variable<String?>(nil)
    let phoneNum = Variable<String?>(nil)
    let dealSetting = Variable<Bool>(false)
    let oldPassword = Variable<String?>(nil)
    let newPassword = Variable<String?>(nil)
    let repeatPassword = Variable<String?>(nil)
    let saveButtonDidTap = PublishSubject<Void>()
    let exitButtonDidTap = PublishSubject<Void>()
    
    // MARK: Output
    let firstNameErrorMessage = PublishSubject<String?>()
    let lastNameErrorMessage = PublishSubject<String?>()
    let middleNameErrorMessage = PublishSubject<String?>()
    let emailErrorMessage = PublishSubject<String?>()
    let phoneNumErrorMessage = PublishSubject<String?>()
    let oldPasswordErrorMessage = PublishSubject<String?>()
    let repeatPasswordErrorMessage = PublishSubject<String?>()
    let newPasswordErrorMessage = PublishSubject<String?>()
    let userChangedSuccess = PublishSubject<Void>()
    let errorMessage = PublishSubject<String>()
    let isLoading: Driver<Bool>
    
    // MARK: Private
    private let errorFabric = ErrorMessageFabric()
    private let activityIndicator = ActivityIndicator()
    private let authManager: AuthManager
    private let bag = DisposeBag()
    
    init(user: AuthUserType, authManager: AuthManager) {
        self.authManager = authManager
        
        isLoading = activityIndicator
            .asDriver()
        
        saveButtonDidTap
            .bind(onNext: { [unowned self] in
                self.saveProfile()
            })
            .disposed(by: bag)
        
        exitButtonDidTap
            .bind(onNext: { [unowned self] in
                self.logOut()
            })
            .disposed(by: bag)
        
        showUserInfo(user.info)
    }
    
    private func showUserInfo(_ user: UserInfo) {
        self.firstName.value = user.firstName
        self.lastName.value = user.lastName
        self.middleName.value = user.middleName
        self.email.value = user.email
        self.phoneNum.value = user.phoneNumber
        self.dealSetting.value = user.receivePromo
    }
    
    private func saveProfile() {
        let formErrors = getValidationErrors()
        
        if formErrors.isEmpty {
            clearAllErrors()
            saveProfileOnServer()
            return
        }
        
        handleValidationErrors(errors: formErrors)
    }
    
    private func saveProfileOnServer() {
        var userInfo = authManager.currenUser!.info
        userInfo.firstName = firstName.value
        userInfo.middleName = middleName.value
        userInfo.lastName = lastName.value
        userInfo.email = email.value
        userInfo.receivePromo = dealSetting.value
        
        var passInfo: NewPasswordContainer?
        
        if let oldPassword = oldPassword.value, let newPassword = newPassword.value, let repeatPassword = repeatPassword.value {
            passInfo = NewPasswordContainer(
                oldPassword: oldPassword,
                newPassword: newPassword,
                repeatPassword: repeatPassword)
        }
        
        authManager.currenUser!.update(userInfo: userInfo, passwordInfo: passInfo)
            .trackActivity(activityIndicator)
            .asCompletable()
            .subscribe(onCompleted: { [unowned self] in
                self.userChangedSuccess.onNext(())
            }, onError: { [unowned self] error in
                self.showErrorMessage(error)
            })
            .disposed(by: bag)
    }
    
    private func logOut() {
        authManager.logOut()
            .trackActivity(activityIndicator)
            .asCompletable()
            .subscribe(onCompleted: { [unowned self] in
                self.delegate?.userLogOut()
            }, onError: { [unowned self] error in
                self.showErrorMessage(error)
            })
            .disposed(by: bag)
    }
    
    private func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            self.errorMessage.onNext(textError)
        }
    }
    
    // MARK: - Validation
    enum ProfileInputsError: Error {
        case somePasswordFieldIsEmpty, wrongRepeatPassword, wrongEmail, oldPasswordMinLength, newPasswordMinLength
    }
    
    private func getValidationErrors() -> [ProfileInputsError] {
        var errors: [ProfileInputsError] = []
        
        if !allPasswordsFieldsIsEmpty {
            errors += getPasswordsValidationErrors()
        }
        
        if let email = self.email.value, !email.isEmpty, !validateEmail(enteredEmail: email) {
            errors.append(.wrongEmail)
        }
        
        return errors
    }
    
    private func getPasswordsValidationErrors() -> [ProfileInputsError] {
        var errors: [ProfileInputsError] = []
        
        if somePasswordFieldIsEmpty {
            errors.append(.somePasswordFieldIsEmpty)
        }
        
        if !errors.contains(.somePasswordFieldIsEmpty) {
            if (oldPassword.value ?? "").count < Const.ValidationRules.passwordLength {
                errors.append(.oldPasswordMinLength)
            }
            
            if (newPassword.value ?? "").count < Const.ValidationRules.passwordLength {
                errors.append(.newPasswordMinLength)
            }
            
            if !errors.contains(.newPasswordMinLength) {
                if newPassword.value != repeatPassword.value {
                    errors.append(.wrongRepeatPassword)
                }
            }
        }
        
        return errors
    }
    
    private var allPasswordsFieldsIsEmpty: Bool {
        return (newPassword.value ?? "").isEmpty && (oldPassword.value ?? "").isEmpty && (repeatPassword.value ?? "").isEmpty
    }
    
    private var somePasswordFieldIsEmpty: Bool {
        return (newPassword.value ?? "").isEmpty || (oldPassword.value ?? "").isEmpty || (repeatPassword.value ?? "").isEmpty
    }
    
    func validateEmail(enteredEmail: String) -> Bool {
        let emailFormat = Const.ValidationRules.emailFormat
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    private func handleValidationErrors(errors: [ProfileInputsError]) {
        for error in errors {
            showError(error: error)
        }
    }
    
    private func showError(error: ProfileInputsError) {
        switch error {
        case .somePasswordFieldIsEmpty:
            if  (newPassword.value ?? "").isEmpty {
                let errorString = makeRequireTextErrors()
                newPasswordErrorMessage.onNext(errorString)
            }
            
            if  (oldPassword.value ?? "").isEmpty {
                let errorString = makeRequireTextErrors()
                oldPasswordErrorMessage.onNext(errorString)
            }
            
            if  (repeatPassword.value ?? "").isEmpty {
                let errorString = makeRequireTextErrors()
                repeatPasswordErrorMessage.onNext(errorString)
            }
        case .wrongRepeatPassword:
            newPasswordErrorMessage.onNext("Пароли не совпадают")
            repeatPasswordErrorMessage.onNext("Пароли не совпадают")
        case .wrongEmail:
            emailErrorMessage.onNext("Не верный формат эл.почты")
        case .oldPasswordMinLength:
            let errorString = makeMinLengthErrors()
            oldPasswordErrorMessage.onNext(errorString)
        case .newPasswordMinLength:
            let errorString = makeMinLengthErrors()
            newPasswordErrorMessage.onNext(errorString)
        }
    }
    
    private func makeMinLengthErrors() -> String {
        let countStrint = Const.ValidationRules.passwordLength.pluralForm(form1: "символ", form2: "символа", form5: "символов")
        return "Пароль должен содержать не менее \(Const.ValidationRules.passwordLength) \(countStrint)"
    }
    
    private func makeRequireTextErrors() -> String {
        return "Обязательно для заполнения"
    }
    
    private func clearAllErrors() {
        firstNameErrorMessage.onNext(nil)
        lastNameErrorMessage.onNext(nil)
        middleNameErrorMessage.onNext(nil)
        emailErrorMessage.onNext(nil)
        phoneNumErrorMessage.onNext(nil)
        oldPasswordErrorMessage.onNext(nil)
        repeatPasswordErrorMessage.onNext(nil)
        newPasswordErrorMessage.onNext(nil)
    }
    
}
