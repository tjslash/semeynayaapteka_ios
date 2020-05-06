//
//  CodeVerificationWithPasswordPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 07.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class ChangePasswordViewController: ScrollViewController {
    
    private let titleLabel = UILabel.titleLabel
    private let codeField = UILabel.codeField
    private let newPasswordField = UILabel.newPasswordField
    private let repeatedPasswordField = UILabel.repeatedPasswordField
    private let sendCodeRepeteView = SendCodeRepeteView(seconds: Const.disableSendingConfirmationSMS)
    private let restoreButton = ActionButton(title: "Восстановить".uppercased())
    private let viewModel: ChangePasswordViewModel
    private let bag = DisposeBag()

    init(viewModel: ChangePasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        addDoneToolBar(textField: codeField)
        setupCodeRepeteView()
        setupDelegates()
        binding()
    }
    
    override public func setupLayout() {
        super.setupLayout()
        
        codeField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        newPasswordField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        repeatedPasswordField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        let fieldStackView = UIStackView(arrangedSubviews: [codeField, newPasswordField, repeatedPasswordField])
        fieldStackView.axis = .vertical
        fieldStackView.alignment = .fill
        fieldStackView.spacing = 16
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(fieldStackView)
        contentView.addSubview(sendCodeRepeteView)
        contentView.addSubview(restoreButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.centerX.equalToSuperview()
        }
        
        fieldStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
        }
        
        sendCodeRepeteView.snp.makeConstraints { make in
            make.top.equalTo(fieldStackView.snp.bottom).offset(40)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.top.equalTo(sendCodeRepeteView.snp.bottom).offset(40)
            make.height.equalTo(48)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    private func setupCodeRepeteView() {
        sendCodeRepeteView.start()
        sendCodeRepeteView.didTapAction = { [unowned self] in self.viewModel.sendSMSCode() }
    }
    
    private func binding() {
        inputBinding()
        outputBinding()
    }
    
    private func inputBinding() {
        codeField.rx.text
            .orEmpty
            .bind(to: viewModel.smsCode)
            .disposed(by: bag)
        
        repeatedPasswordField.rx.text
            .orEmpty
            .bind(to: viewModel.repeatedPassword)
            .disposed(by: bag)
        
        restoreButton.rx.tap
            .bind(to: viewModel.restoreButtonDidTap)
            .disposed(by: bag)
        
        newPasswordField.rx.text
            .orEmpty
            .bind(to: viewModel.newPassword)
            .disposed(by: bag)
    }
    
    private func outputBinding() {
        viewModel.restoreButtonisEnable
            .drive(onNext: { [unowned self] isEnabled in
                self.restoreButton.isEnabled = isEnabled
                self.restoreButton.alpha = isEnabled ? 1.0 : 0.5
            })
            .disposed(by: bag)
        
        viewModel.changePasswordSuccess
            .bind(onNext: { [unowned self] _ in
                self.showSuccessAlert()
            })
            .disposed(by: bag)
        
        viewModel.changePasswordError
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.sendSmsCodeError
            .do(onNext: { [unowned self]  _ in
                self.sendCodeRepeteView.stop()
            })
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.newPasswordError
            .bind(to: newPasswordField.rx.errorMessage)
            .disposed(by: bag)
        
        viewModel.repeatedPasswordError
            .bind(to: repeatedPasswordField.rx.errorMessage)
            .disposed(by: bag)
    }
    
    private func setupDelegates() {
        codeField.delegate = self
        newPasswordField.delegate = self
        repeatedPasswordField.delegate = self
    }

    private func showSuccessAlert() {
        let alert = UIAlertController(title: nil, message: "Пароль успешно изменен", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .cancel) { [unowned self] _ in
            self.viewModel.passToDelegateSuccess()
        }
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate
extension ChangePasswordViewController: UITextFieldDelegate {
    
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

// MARK: Static UILabel fabic
private extension UILabel {
    
    static var titleLabel: UILabel {
        let lable = UILabel()
        lable.text = "Проверка кода".uppercased()
        lable.textAlignment = .center
        lable.textColor = .taPrimary
        lable.font = UIFont(name: "Roboto-Medium", size: 20)
        return lable
    }
    
    static var codeField: FlatTextField {
        let textField = FlatTextField()
        textField.keyboardType = .numberPad
        textField.placeholder = "Введите код, полученный по СМС"
        textField.font = UIFont.Title.h3
        return textField
    }
    
    static var newPasswordField: FlatTextField {
        let textField = FlatTextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Пароль"
        textField.font = UIFont.Title.h3
        return textField
    }
    
    static var repeatedPasswordField: FlatTextField {
        let textField = FlatTextField()
        textField.placeholder = "Повторите пароль"
        textField.isSecureTextEntry = true
        textField.font = UIFont.Title.h3
        return textField
    }
    
}
