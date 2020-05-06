//
//  AboutBonusCardView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 18.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class AboutBonusCardView: UIView {
    
    public var onButtonTap: (() -> Void)?
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "Семейная дисконтная карта даёт право на приобретение товаров из ассортимента аптек формата «Семейная аптека» со скидкой от 5 до 10%."
        label.numberOfLines = 0
        return label
    }()
    
    private let infoButton = InfoButton(title: "Подробнее о дисконтной карте".uppercased())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = .clear
        infoButton.addTarget(self, action: #selector(onButtonTapHandler), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(descriptionLabel)
        addSubview(infoButton)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
        }
        
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.height.equalTo(48)
            make.right.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    @objc
    private func onButtonTapHandler() {
        onButtonTap?()
    }
}
