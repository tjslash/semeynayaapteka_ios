//
//  ReviewPage.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 19/03/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateReviewViewController: BaseViewController {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Оставить отзыв или задать вопрос Вы можете через форму ниже."
        label.numberOfLines = 2
        return label
    }()
    
    lazy var phoneNumField: FlatTextField = {
        let textField = FlatTextField()
        textField.placeholder = "Номер телефона"
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }()
    
    lazy var userNameField: FlatTextField = {
        let textField = FlatTextField()
        textField.placeholder = "Имя пользователя"
        textField.keyboardType = .default
        return textField
    }()
    
    lazy var reviewTextField: UITextView = {
        let textField = UITextView()
        textField.delegate = self
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.taLightGray.cgColor
        textField.layer.cornerRadius = 4
        textField.textContainerInset  = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textField.font = .placeholder
        textField.backgroundColor = .taAlmostWhite
        return textField
    }()
    
    let sendButton = ActionButton(title: "Отправить".uppercased())

    private let viewModel: CreateReviewViewModel
    private let bag = DisposeBag()

    weak var delegate: BaseViewControllerDelegate?
    
    init(viewModel: CreateReviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .taAlmostWhite
        title = "Обратная связь"
        addSearchBarButton()
        addDoneToolBar(textField: phoneNumField)
        binding()
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [textLabel, userNameField, phoneNumField, reviewTextField, sendButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-20)
        }
        
        userNameField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        phoneNumField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        sendButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        reviewTextField.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(150)
        }
    }
    
    private func binding() {
        userNameField.isHidden = true
        phoneNumField.isHidden = viewModel.phoneIsHidden
        
        sendButton.rx.tap
            .bind(to: viewModel.sendFeedBackButtonDidTap)
            .disposed(by: bag)
        
        (reviewTextField.rx.text <-> viewModel.feedBack).disposed(by: bag)
        (userNameField.rx.text <-> viewModel.name).disposed(by: bag)
        (phoneNumField.rx.text <-> viewModel.phone).disposed(by: bag)
        
        viewModel.sendFeedBackError
            .bind(onNext: { [unowned self] error in
                self.handleError(error)
            })
            .disposed(by: bag)
        
        viewModel.sendFeedBackSuccess
            .bind(onNext: { [unowned self] _ in
                self.showSuccessAlert()
            })
            .disposed(by: bag)
        
        viewModel.sendFeedBackButtonIsEnable
            .drive(sendButton.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        sendButton.rx.tap
            .bind(onNext: { [unowned self] _ in
                self.clearTextFieldErrors()
            })
            .disposed(by: bag)
    }
    
    override func handleError(_ error: Error) {
        guard let serviceError = error as? ServiceError else {
            super.handleError(error)
            return
        }
        
        switch serviceError {
        case .validation(let bagError):
            if let text = bagError[.phone].firstMessage {
                phoneNumField.errorMessage = text
            }
        default:
            super.handleError(error)
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: nil, message: "Ваше сообщение успешно отправлено, спасибо за оставленный отзыв", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func clearTextFieldErrors() {
        userNameField.errorMessage = nil
        phoneNumField.errorMessage = nil
    }
    
}

// MARK: UITextViewDelegate
extension CreateReviewViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

// MARK: UITextFieldDelegate
extension CreateReviewViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textField = textField as? FlatTextField {
            textField.errorMessage = nil
        }
        
        textField.applyPhoneMask(shouldChangeCharactersIn: range, replacementString: string)
        return false
    }
    
}
