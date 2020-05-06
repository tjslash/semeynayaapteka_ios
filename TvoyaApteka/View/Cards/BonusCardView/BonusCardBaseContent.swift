//
//  BonusCardBaseContent.swift
//  TvoyaApteka
//
//  Created by BuidMac on 19.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class BonusCardBaseContent: CardView {
    
//    private let iconView: UIImageView = {
//        let imageView = UIImageView(image: UIImage(named: "BonusPercent"))
//        imageView.tintColor = UIColor.taPrimary
//        return imageView
//    }()
    
    private let logoImageView: UIImageView = {
        let logo = UIImageView()
        let image = UIImage(named: "Bonus_logo")
        logo.image = image
        return logo
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 10
        backgroundColor = UIColor.taPrimary
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupLayout() {
//        addSubview(iconView)
        addSubview(logoImageView)
      
//        iconView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.right.equalToSuperview().offset(-14)
//            make.width.equalTo(43)
//            make.height.equalTo(55)
//        }
        
        logoImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(80)
            make.width.equalTo(140)
        }
    }
    
}
