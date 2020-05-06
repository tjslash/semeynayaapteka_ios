//
//  HintLabel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

@IBDesignable
public class HintLabel: Label {
    
    override func applyStyle() {
        self.textColor = .taGray
        self.font = .normalText
        self.numberOfLines = 0
    }
    
}
