//
//  SecondaryActionButton.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

@IBDesignable
public class SecondaryActionButton: RoundButton {
    
    override func applyStyle() {
        super.applyStyle()
        self.setTitleColor(.taPrimary, for: .normal)
        self.backgroundColor = .white
        self.titleLabel?.font = .buttonTitle
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.taPrimary.cgColor
    }
    
}
