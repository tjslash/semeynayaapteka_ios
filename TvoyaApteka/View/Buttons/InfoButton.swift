//
//  InfoButton.swift
//  TvoyaApteka
//
//  Created by BuidMac on 19.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

@IBDesignable
public class InfoButton: RoundButton {
    
    override func applyStyle() {
        super.applyStyle()
        self.setTitleColor(.lightGray, for: .normal)
        self.backgroundColor = .taAlmostWhite
        self.titleLabel?.font = UIFont.buttonTitle
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
