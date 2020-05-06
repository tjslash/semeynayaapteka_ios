//
//  HintButton.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

@IBDesignable
public class HintButton: RoundButton {
    
    override func applyStyle() {
        super.applyStyle()
        self.backgroundColor = .clear
        self.setTitleColor(.taGray, for: .normal)
        self.setTitleColor(.taLightPrimary, for: .highlighted)
        self.titleLabel?.font = .normalText
    }
    
}
