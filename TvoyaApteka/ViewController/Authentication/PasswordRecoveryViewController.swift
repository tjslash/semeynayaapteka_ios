//
//  PasswordRecovery.swift
//  TvoyaApteka
//
//  Created by oleg shkreba on 09.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class PasswordRecoveryViewController: ScrollViewController {

    private let titlePageLabel = TitleLabel(text: "Восстановление пароля".uppercased())
    private let sendSmsButton = ActionButton(title: "Отправить смс".uppercased())
    private let phoneNum = UITextField.phoneNum
    private let viewModel: PasswordRecoveryViewModel
    private let bag = DisposeBag()
    
    init(viewModel: PasswordRecoveryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneToolBar(textField: phoneNum)
        self.title = "Восстановление пароля"
        view.backgroundColor = .taAlmostWhite
        phoneNum.delegate = self
        binding()
    }
    
    override func setupLayout() {
        super.setupLayout()
        contentView.addSubview(titlePageLabel)
        contentView.addSubview(phoneNum)
        contentView.addSubview(sendSmsButton)
        
        titlePageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.centerX.equalToSuperview()
        }
        
        phoneNum.snp.makeConstraints { make in
            make.top.equalTo(titlePageLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(50)
            make.right.equalToSuperview().offset(-20)
        }
        
        sendSmsButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNum.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(48)
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
        
        sendSmsButton.rx.tap
            .bind(to: viewModel.sendSmsButtonDidTap)
            .disposed(by: bag)
        
        sendSmsButton.rx.tap
            .map({ nil })
            .bind(to: phoneNum.rx.errorMessage)
            .disposed(by: bag)
    }
    
    private func outputBinding() {
        viewModel.sendSmsButtonIsEnable
            .drive(onNext: { [unowned self] isEnabled in
                self.sendSmsButton.isEnabled = isEnabled
                self.sendSmsButton.alpha = isEnabled ? 1.0 : 0.5
            })
            .disposed(by: bag)
        
        viewModel.sendSmsError
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.phoneError
            .bind(to: phoneNum.rx.errorMessage)
            .disposed(by: bag)
    }

}

extension PasswordRecoveryViewController: UITextFieldDelegate {
    
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
    
}

// MARK: - Static UITextField fabric
private extension UITextField {
    
    static var phoneNum: FlatTextField {
        let textField = FlatTextField()
        textField.keyboardType = .numberPad
        textField.placeholder = "Введите Ваш номер телефона"
        textField.font = UIFont.Title.h3
        return textField
    }
    
}
