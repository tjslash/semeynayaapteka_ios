//
//  EditProfilePage.swift
//  TvoyaApteka
//
//  Created by oleg shkreba on 20.04.2018.
//  Update by BuidMac on 04.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class ProfileViewController: ScrollViewController {
    
    private let namesTitleLabel: UILabel = {
        let label = UILabel(text: "Личные данные")
        label.font = UIFont.Title.h2Bold
        label.textColor = .taPrimary
        return label
    }()
    
    private let lastName = FlatTextField(placeholder: "Фамилия")
    private let firstName = FlatTextField(placeholder: "Имя")
    private let middleName = FlatTextField(placeholder: "Отчество")
    private let email = FlatTextField(placeholder: "Email")
    
    private let passwordTitleLabel: UILabel = {
        let label = UILabel(text: "Изменить пароль")
        label.font = UIFont.Title.h2Bold
        return label
    }()
    
    private let oldPassword = FlatTextField(placeholder: "Старый пароль")
    private let newPassword = FlatTextField(placeholder: "Новый пароль")
    private let repeatPassword = FlatTextField(placeholder: "Повторить пароль")

    private let phoneNum: FlatTextField = {
        let textField = FlatTextField()
        textField.text = "Телефон"
        textField.textColor = .taLightGray
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private let settingTitleLabel: UILabel = {
        let label = UILabel(text: "Подписки")
        label.font = UIFont.Title.h2Bold
        return label
    }()
    
    private let dealSetting = SettingView()
    private let saveButton = FlatButton(title: "Сохранить".uppercased())
    private let exitButton = FlatButton(title: "Выход".uppercased())
    
    private let viewModel: ProfileViewModel
    private let bag = DisposeBag()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        title = "Профиль"
        dealSetting.title = "Получать актуальные акции"
        setupLayout()
        setupInputs()
        binding()
    }
    
    private func setupInputs() {
        firstName.delegate = self
        lastName.delegate = self
        middleName.delegate = self
        email.delegate = self
        oldPassword.delegate = self
        oldPassword.isSecureTextEntry = true
        newPassword.delegate = self
        newPassword.isSecureTextEntry = true
        repeatPassword.delegate = self
        repeatPassword.isSecureTextEntry = true
    }

    override func setupLayout() {
        super.setupLayout()
        
        let infoStackView = UIStackView(arrangedSubviews: [namesTitleLabel, lastName, firstName, middleName, email, phoneNum])
        infoStackView.axis = .vertical
        infoStackView.spacing = 16
        
        let passwordStackView = UIStackView(arrangedSubviews: [passwordTitleLabel, oldPassword, newPassword, repeatPassword])
        passwordStackView.axis = .vertical
        passwordStackView.spacing = 16
        
        let buttonsStackView = UIStackView(arrangedSubviews: [saveButton, UIView(), exitButton])
        buttonsStackView.axis = .horizontal
        
        let mainStackView = UIStackView(arrangedSubviews: [infoStackView, passwordStackView, settingTitleLabel, dealSetting, buttonsStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 30
        
        contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-17)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    private func binding() {
        bindingInput()
        bindingOutput()
        bindingErrors()
    }
    
    private func bindingInput() {
        saveButton.rx.tap
            .bind(to: viewModel.saveButtonDidTap)
            .disposed(by: bag)
        
        exitButton.rx.tap
            .bind(to: viewModel.exitButtonDidTap)
            .disposed(by: bag)

        (firstName.rx.text <-> viewModel.firstName).disposed(by: bag)
        (lastName.rx.text <-> viewModel.lastName).disposed(by: bag)
        (middleName.rx.text <-> viewModel.middleName).disposed(by: bag)
        (email.rx.text <-> viewModel.email).disposed(by: bag)
        (phoneNum.rx.text <-> viewModel.phoneNum).disposed(by: bag)
        (dealSetting.controlSwitch.rx.isOn <-> viewModel.dealSetting).disposed(by: bag)
        
        (oldPassword.rx.text <-> viewModel.oldPassword).disposed(by: bag)
        (newPassword.rx.text <-> viewModel.newPassword).disposed(by: bag)
        (repeatPassword.rx.text <-> viewModel.repeatPassword).disposed(by: bag)
    }
    
    private func bindingOutput() {
        viewModel.isLoading
            .asDriver()
            .drive(onNext: { [unowned self] isLoading in
                isLoading ? self.showPreloader() : self.hidePreloader()
            })
            .disposed(by: bag)
        
        viewModel.userChangedSuccess
            .bind(onNext: { [unowned self] _ in
                self.clearPaswordFields()
                self.showDoneAlert(message: "Профиль успешно изменен")
            })
            .disposed(by: bag)
    }
    
    private func bindingErrors() {
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.firstNameErrorMessage
            .bind(to: firstName.rx.errorMessage)
            .disposed(by: bag)
        
        viewModel.lastNameErrorMessage
            .bind(to: lastName.rx.errorMessage)
            .disposed(by: bag)
        
        viewModel.middleNameErrorMessage
            .bind(to: middleName.rx.errorMessage)
            .disposed(by: bag)
        
        viewModel.emailErrorMessage
            .bind(to: email.rx.errorMessage)
            .disposed(by: bag)
        
        viewModel.phoneNumErrorMessage
            .bind(to: phoneNum.rx.errorMessage)
            .disposed(by: bag)
        
        viewModel.oldPasswordErrorMessage
            .bind(to: oldPassword.rx.errorMessage)
            .disposed(by: bag)
        
        viewModel.newPasswordErrorMessage
            .bind(to: newPassword.rx.errorMessage)
            .disposed(by: bag)
        
        viewModel.repeatPasswordErrorMessage
            .bind(to: repeatPassword.rx.errorMessage)
            .disposed(by: bag)
    }
    
    override func handleError(_ error: Error) {
        guard let serviceError = error as? ServiceError else {
            super.handleError(error)
            return
        }
        
        switch serviceError {
        case .validation(let bagError):
            if let text = bagError[.oldPassword].firstMessage {
                oldPassword.errorMessage = text
            }
        default:
            showDoneAlert(message: "Ошибка сервера, попробуйте позже")
        }
    }
    
    private func clearPaswordFields() {
        oldPassword.text = nil
        newPassword.text = nil
        repeatPassword.text = nil
    }
    
    private func showDoneAlert(message: String) {
        let alert = createDoneAlert(message: message)
        present(alert, animated: true, completion: nil)
    }
    
    private func createDoneAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(doneAction)
        return alert
    }

}

fileprivate extension UITextField {
    
    convenience init(placeholder: String?) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }
    
}

// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textField = textField as? FlatTextField {
            textField.errorMessage = nil
        }
        
        return true
    }
    
}
