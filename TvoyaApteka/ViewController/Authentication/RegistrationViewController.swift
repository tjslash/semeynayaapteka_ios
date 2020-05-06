//
//  RegistrationPage.swift
//  TvoyaApteka
//
//  Created by oleg shkreba on 18.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class RegistrationViewController: ScrollViewController {

    private let titlePageLabel = TitleLabel(text: "Регистрация".uppercased())
    private let phoneNum = UITextField.phoneNum
    private let password = UITextField.password
    private let passwordRepeat = UITextField.passwordRepeat
    private let registerButton = ActionButton(title: "Регистрация".uppercased())
    private let notifyLabel = UILabel.notifyLabel
    private let viewModel: RegistrationViewModel
    private let bag = DisposeBag()
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Регистрация"
        view.backgroundColor = .taAlmostWhite
        addDoneToolBar(textField: phoneNum)
        phoneNum.delegate = self
        password.delegate = self
        passwordRepeat.delegate = self
        binding()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        let inputsStackView = UIStackView(arrangedSubviews: [phoneNum, password, passwordRepeat])
        inputsStackView.spacing = 16
        inputsStackView.alignment = .fill
        inputsStackView.axis = .vertical
        
        phoneNum.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        password.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        passwordRepeat.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        contentView.addSubview(titlePageLabel)
        contentView.addSubview(inputsStackView)
        contentView.addSubview(registerButton)
        contentView.addSubview(notifyLabel)
        
        titlePageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.centerX.equalToSuperview()
        }
        
        inputsStackView.snp.makeConstraints { make in
            make.top.equalTo(titlePageLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(inputsStackView.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(48)
        }
        
        notifyLabel.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    private func binding() {
        inputBinding()
        outputBinding()
    }
    
    private func inputBinding() {
        phoneNum.rx.text
            .orEmpty
            .bind(to: viewModel.phone)
            .disposed(by: bag)
        
        password.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: bag)
        
        passwordRepeat.rx.text
            .orEmpty
            .bind(to: viewModel.passwordRepeat)
            .disposed(by: bag)
        
        registerButton.rx.tap
            .bind(to: viewModel.registrationButtonDidTap)
            .disposed(by: bag)
    }
    
    private func outputBinding() {
        viewModel.registrationButtonIsEnable
            .drive(onNext: { [unowned self] isEnable in
                self.registerButton.isEnabled = isEnable
                self.registerButton.alpha = isEnable ? 1.0 : 0.5
            })
            .disposed(by: bag)
        
        viewModel.registrationError
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.passwordError
            .bind(to: password.rx.errorMessage)
            .disposed(by: bag)
        
        viewModel.passwordRepeatError
            .bind(to: passwordRepeat.rx.errorMessage)
            .disposed(by: bag)
        
        viewModel.phoneError
            .bind(to: phoneNum.rx.errorMessage)
            .disposed(by: bag)
    }
    
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textField = textField as? FlatTextField {
            textField.errorMessage = nil
        }
        
        if textField === phoneNum {
            textField.applyPhoneMask(shouldChangeCharactersIn: range, replacementString: string)
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}

// MARK: Static UITextField Fabric
private extension UITextField {
    
    static var phoneNum: FlatTextField {
        let textField = FlatTextField()
        textField.placeholder = "Номер телефона"
        textField.keyboardType = .numberPad
        textField.font = UIFont.Title.h3
        return textField
    }
    
    static var password: FlatTextField {
        let textField = FlatTextField()
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        textField.font = UIFont.Title.h3
        return textField
    }
    
    static var passwordRepeat: FlatTextField {
        let textField = FlatTextField()
        textField.placeholder = "Повторите пароль"
        textField.isSecureTextEntry = true
        textField.font = UIFont.Title.h3
        return textField
    }
    
}

// MARK: Static UILabel Fabric
private extension UILabel {
    
    static var notifyLabel: HintLabel {
        let label = HintLabel(text: "* Нажимая кнопку \n\"Зарегистрироваться\", Вы принимаете условия Политики конфиденциальности")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
}
