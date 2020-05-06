//
//  BonusCardNotActiveView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 19.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class BonusCardNotActiveView: UIView {
    
    public var activateBonusCardAction: ((String) -> Void)?
    public var aboutBonusProgrammAction: (() -> Void)?
    
    public let bonusCardView = NotActiveBonusCard()
    private let activateButton = ActionButton(title: "Активировать карту".uppercased())
    
    private let sepetationLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let aboutBonusCardView = AboutBonusCardView()
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.taAlmostWhite
        bonusCardView.cardNumbField.delegate = self
        setupLayout()
        setupActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(bonusCardView)
        addSubview(activateButton)
        addSubview(sepetationLineView)
        addSubview(aboutBonusCardView)
        
        bonusCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(414)
            make.height.equalTo(200)
        }
        
        activateButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(48)
            make.top.equalTo(bonusCardView.snp.bottom).offset(15)
        }
        
        sepetationLineView.snp.makeConstraints { make in
            make.top.equalTo(activateButton.snp.bottom).offset(40)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        aboutBonusCardView.snp.makeConstraints { make in
            make.top.equalTo(sepetationLineView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupActions() {
        aboutBonusCardView.onButtonTap = { [unowned self] in
            self.aboutBonusProgrammAction?()
        }
    
        activateButton.addTarget(self, action: #selector(activateButtonHandler), for: .touchUpInside)
        checkValidCard()
    }
    
    @objc
    private func activateButtonHandler() {
        activateBonusCardAction?(String(bonusCardView.cardNumbField.text!.digits))
    }
    
    private func checkValidCard() {
        let numCardIsActive = bonusCardView.cardNumbField.rx.text
            .orEmpty
            .map { text -> Bool in
                let mask = Const.Mask.bonusCard
                return text.count == mask.count
            }
        
        numCardIsActive.bind(to: activateButton.rx.isEnabled).disposed(by: bag)
    }
    
}

// MARK: UITextFieldDelegate
extension BonusCardNotActiveView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.applyBonusCardMask(shouldChangeCharactersIn: range, replacementString: string)
        return false
    }
    
}
