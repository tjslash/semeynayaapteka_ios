//
//  NotActiveBonusCard.swift
//  TvoyaApteka
//
//  Created by BuidMac on 19.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class NotActiveBonusCard: BonusCardBaseContent {
    
    // MARK: Public API
    
    // Discription text under text field
    public var descriptionText: String? {
        get {
            return titleLabel.text
        }
        set(text) {
            titleLabel.text = text
        }
    }
    
    public private(set) lazy var cardNumbField: UITextField = {
        let textField = CardNumbField()
        textField.layer.cornerRadius = 3
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.textColor = UIColor.taAlmostWhite
        let clearButton = UIButton()
        let templateImage = #imageLiteral(resourceName: "Close").withRenderingMode(.alwaysTemplate)
        clearButton.setImage(templateImage, for: .normal)
        clearButton.tintColor = UIColor.lightGray
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        clearButton.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        textField.rightView = clearButton
        textField.rightViewMode = .always
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }()
    
     // MARK: Private API
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "Введите номер карты"
        return label
    }()
    
    override public func setupLayout() {
        super.setupLayout()
        
        addSubview(cardNumbField)
        addSubview(titleLabel)
        
        cardNumbField.snp.makeConstraints { make in
            make.height.equalTo(41)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(cardNumbField)
            make.right.equalTo(cardNumbField)
            make.bottom.equalToSuperview().offset(-31)
        }
    }
    
    @objc
    private func clearText() {
        cardNumbField.text = nil
    }
    
}

// MARK: - UITextFieldDelegate
extension NotActiveBonusCard: UITextFieldDelegate {
    
}

private class CardNumbField: UITextField {
    
    private let textInsert = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let sourceRect = super.textRect(forBounds: bounds)
        let newRect = UIEdgeInsetsInsetRect(sourceRect, textInsert)
        return newRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let sourceRect = super.editingRect(forBounds: bounds)
        let newRect = UIEdgeInsetsInsetRect(sourceRect, textInsert)
        return newRect
    }
    
}
