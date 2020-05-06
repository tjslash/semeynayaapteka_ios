//
//  AuthorizationPage.swift
//  TvoyaApteka
//
//  Created by oleg shkreba on 18.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class LoginViewController: ScrollViewController {
    
    private let titlePageLabel = UILabel.titlePageLabel
    private let loginButton = UIButton.loginButton
    private let forgotButton = UIButton.forgotButton
    private let registrationButton = UIButton.registrationButton
    private let phoneNumInput = FlatTextField.phoneNumInput
    private var passwordInput = FlatTextField.passwordInput
    
    private var viewModel: LoginViewModel
    private let bag = DisposeBag()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        self.title = "Вход"
        addDoneToolBar(textField: phoneNumInput)
        phoneNumInput.delegate = self
        binding()
    }
    
    override func setupLayout() {
        super.setupLayout()
        let inputsStackView = UIStackView(arrangedSubviews: [phoneNumInput, passwordInput])
        inputsStackView.spacing = 16
        inputsStackView.alignment = .fill
        inputsStackView.axis = .vertical
        
        phoneNumInput.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        passwordInput.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        contentView.addSubview(titlePageLabel)
        contentView.addSubview(inputsStackView)
        contentView.addSubview(loginButton)
        contentView.addSubview(forgotButton)
        contentView.addSubview(registrationButton)
        
        titlePageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.centerX.equalToSuperview()
        }
        
        inputsStackView.snp.makeConstraints { make in
            make.top.equalTo(titlePageLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(inputsStackView.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(48)
        }
        
        forgotButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        registrationButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(forgotButton.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(48)
        }
    }
    
    private func binding() {
        inputBinding()
        outputBinding()
    }
    
    private func inputBinding() {
        loginButton.rx.tap
            .bind(to: viewModel.loginButtonDidTap)
            .disposed(by: bag)
        
        phoneNumInput.rx.text
            .orEmpty
            .bind(to: viewModel.phone)
            .disposed(by: bag)
        
        passwordInput.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: bag)
        
        registrationButton.rx.tap
            .bind(to: viewModel.registrationButtonDidTap)
            .disposed(by: bag)
        
        forgotButton.rx.tap
            .bind(to: viewModel.forgotButtonDidTap)
            .disposed(by: bag)
    }
    
    private func outputBinding() {
        viewModel.loginButtonIsEnable
            .drive(onNext: { [unowned self] isEnable in
                self.loginButton.isEnabled = isEnable
                self.loginButton.alpha = isEnable ? 1.0 : 0.5
            })
            .disposed(by: bag)
        
        viewModel.loginError
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.phoneError
            .bind(to: phoneNumInput.rx.errorMessage)
            .disposed(by: bag)
        
        viewModel.passwordError
            .bind(to: passwordInput.rx.errorMessage)
            .disposed(by: bag)
    }
    
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === phoneNumInput {
            textField.applyPhoneMask(shouldChangeCharactersIn: range, replacementString: string)
            return false
        }
        
        return true
    }
    
}

// MARK: - Static UILabel fabric
private extension UILabel {

    static var titlePageLabel: UILabel {
        return  TitleLabel(text: "Вход".uppercased())
    }

}

// MARK: - Static UIButton fabric
private extension UIButton {
    
    static var loginButton: UIButton {
        return ActionButton(title: "Войти".uppercased())
    }
    
    static var forgotButton: UIButton {
        return HintButton(title: "Забыли пароль")
    }
    
    static var registrationButton: UIButton {
        return FlatButton(title: "Регистрация".uppercased())
    }
    
}

// MARK: - Static UITextField fabric
private extension FlatTextField {
    
    static var phoneNumInput: FlatTextField {
        let textField = FlatTextField()
        textField.keyboardType = .numberPad
        textField.font = UIFont.Title.h3
        textField.placeholder = "Номер телефона"
        return textField
    }
    
    static var passwordInput: FlatTextField {
        let textField = FlatTextField()
        textField.isSecureTextEntry = true
        textField.font = UIFont.Title.h3
        textField.placeholder = "Пароль"
        return textField
    }
    
}
