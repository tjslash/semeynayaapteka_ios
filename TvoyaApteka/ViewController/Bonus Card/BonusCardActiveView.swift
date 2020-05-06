//
//  BonusCardActiveView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 19.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

class BonusCardActiveView: UIView {
    
    public var aboutBonusProgrammAction: (() -> Void)?
    public var showAllHistoryAction: (() -> Void)?
    
    private let bonusCardView = ActiveBonusCard()
    private let aboutBonusCardView = AboutBonusCardView()
//    private let listOperationsView = ListOperationsView()
    
    init(bonusCard: BonusCard) {
        super.init(frame: .zero)
        setupLayout()
        setupActions()
        backgroundColor = UIColor.taAlmostWhite
        
//        bonusCardView.bonusCount = Int(bonusCard.amount)
        bonusCardView.cardNum = bonusCard.cardNum
//        listOperationsView.operations = bonusCard.operations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(bonusCardView)
        addSubview(aboutBonusCardView)
//        addSubview(listOperationsView)
        
        bonusCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(414)
            make.height.equalTo(200)
        }
        
        aboutBonusCardView.snp.makeConstraints { make in
            make.top.equalTo(bonusCardView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
//        listOperationsView.snp.makeConstraints { make in
//            make.top.equalTo(aboutBonusCardView.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
    }
    
    private func setupActions() {
        aboutBonusCardView.onButtonTap = { [unowned self] in
            self.aboutBonusProgrammAction?()
        }
        
//        listOperationsView.showAllHistory = { [unowned self] in
//            self.showAllHistoryAction?()
//        }
    }
    
}
