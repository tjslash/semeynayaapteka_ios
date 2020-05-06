//
//  AttentionButton.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

@IBDesignable
public class AttentionButton: RoundButton {

    override func applyStyle() {
        super.applyStyle()
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .taRed
        self.titleLabel?.font = .buttonTitle
        
        self.layer.shadowColor = UIColor.taRed.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        self.layer.shadowRadius = 12.0
        self.layer.shadowOpacity = 0.4
    }
    
}
