//
//  ActionButton.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

@IBDesignable
public class ActionButton: RoundButton {
    
    override func applyStyle() {
        super.applyStyle()
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor.taPrimary
        self.titleLabel?.font = UIFont.buttonTitle
    }
    
}
