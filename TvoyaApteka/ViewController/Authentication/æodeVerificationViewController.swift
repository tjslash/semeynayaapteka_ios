//
//  CodeVerificationPage.swift
//  TvoyaApteka
//
//  Created by oleg shkreba on 19.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class СodeVerificationViewController: ScrollViewController {
    
    private let titleLabel = TitleLabel(text: "Проверка кода".uppercased())
    private let codeField = UITextField.codeField
    private let confirmButton = ActionButton(title: "Подтвердить код".uppercased())
    private let sendCodeRepeteView = SendCodeRepeteView(seconds: Const.disableSendingConfirmationSMS)
    private let bag = DisposeBag()
    private let viewModel: СodeVerificationViewModel
    
    init(viewModel: СodeVerificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneToolBar(textField: codeField)
        view.backgroundColor = .taAlmostWhite
        setupCodeRepeteView()
        binding()
    }
    
    override func setupLayout() {
        super.setupLayout()
        view.addSubview(titleLabel)
        view.addSubview(codeField)
        view.addSubview(confirmButton)
        view.addSubview(sendCodeRepeteView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(54)
            make.centerX.equalToSuperview()
        }
        
        codeField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().offset(-48)
            make.height.equalTo(50)
        }
        
        sendCodeRepeteView.snp.makeConstraints { (make) in
            make.top.equalTo(codeField.snp.bottom).offset(21)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(sendCodeRepeteView.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().offset(-48)
            make.height.equalTo(48)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    private func setupCodeRepeteView() {
        sendCodeRepeteView.start()
        sendCodeRepeteView.didTapAction = { [unowned self] in self.viewModel.sendTheCode() }
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
        
        confirmButton.rx.tap
            .bind(to: viewModel.confirmButtonDidTap)
            .disposed(by: bag)
    }
    
    private func outputBinding() {
        viewModel.confirmButtonIsEnable
            .drive(onNext: { [unowned self] isEnable in
                self.confirmButton.isEnabled = isEnable
                self.confirmButton.alpha = isEnable ? 1.0 : 0.5
            })
            .disposed(by: bag)
        
        viewModel.registrationError
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.smsCodeError
            .bind(to: codeField.rx.errorMessage)
            .disposed(by: bag)
    }
    
}

// MARK: - Static UITextField fabric
private extension UITextField {
    
    static var codeField: FlatTextField {
        let textField = FlatTextField()
        textField.placeholder = "Введите код, полученный по СМС"
        textField.keyboardType = .numberPad
        textField.font = UIFont.Title.h3
        return textField
    }
    
}
