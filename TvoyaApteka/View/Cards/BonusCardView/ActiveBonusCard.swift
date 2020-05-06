//
//  ActiveBonusCard.swift
//  TvoyaApteka
//
//  Created by BuidMac on 18.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class ActiveBonusCard: BonusCardBaseContent {
    
    // MARK: Public API
    
    /// Current count bonus
//    public var bonusCount: Int {
//        get {
//            guard let text = countBonusNumLabel.text, let num = Int(text) else {
//                return 0
//            }
//            return num
//        }
//        set(num) {
//            countBonusNumLabel.text = String(num)
//            countBonusTitleLabel.text = num.pluralForm(form1: "Бонус", form2: "Бонуса", form5: "Бонусов").uppercased()
//        }
//    }
    
    /// Current bonus number
    public var cardNum: String? {
        get {
            return cardNumbLabel.text
        }
        set(text) {
            cardNumbLabel.text = text
        }
    }
    
    // Discription text under text field
    public var descriptionText: String? {
        get {
            return titleLabel.text
        }
        set(text) {
            titleLabel.text = text
        }
    }
    
    // MARK: Private API
//    private let countBonusNumLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .taPrimary
//        label.font = UIFont.systemFont(ofSize: 64)
//        return label
//    }()
//
//    private let countBonusTitleLabel: UILabel = {
//        let label = UILabel()
  
//        label.textColor = .taPrimary
//        label.font = UIFont.systemFont(ofSize: 24)
//        return label
//    }()
    
    private let cardNumbLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.taAlmostWhite
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "Номер карты"
        return label
    }()
    
    override public func setupLayout() {
        super.setupLayout()
        
        addSubview(cardNumbLabel)
        addSubview(titleLabel)
        
//        let bonusWrapper = UIView()
//        addSubview(bonusWrapper)
//        bonusWrapper.addSubview(countBonusNumLabel)
//        bonusWrapper.addSubview(countBonusTitleLabel)
        
//        bonusWrapper.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(30)
//            make.centerX.equalToSuperview()
//        }
        
//        countBonusNumLabel.snp.makeConstraints { make in
//            make.left.top.bottom.equalToSuperview()
//        }
        
//        countBonusTitleLabel.snp.makeConstraints { make in
//            make.right.equalToSuperview()
//            make.left.equalTo(countBonusNumLabel.snp.right).offset(16)
//            make.bottom.equalTo(countBonusNumLabel.snp.lastBaseline)
//        }
//
//        countBonusTitleLabel.setContentHuggingPriority(.init(249), for: .horizontal)
//        countBonusTitleLabel.setContentCompressionResistancePriority(.init(249), for: .horizontal)
        
        cardNumbLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(cardNumbLabel)
            make.right.equalTo(cardNumbLabel)
            make.bottom.equalToSuperview().offset(-31)
        }
    }
    
}
