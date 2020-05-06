//
//  TitleLabel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

@IBDesignable
public class TitleLabel: Label {
    
    override func applyStyle() {
        self.textColor = .taPrimary
        self.font = UIFont.AutorizationPage.title
    }
    
}
