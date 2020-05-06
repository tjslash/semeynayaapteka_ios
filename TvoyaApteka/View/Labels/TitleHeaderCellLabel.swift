//
//  TitleHeaderCellLabel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 25.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class TitleHeaderCellLabel: Label {
    
    override func applyStyle() {
        super.applyStyle()
        self.font = UIFont.Title.h2Bold
        self.textColor = UIColor.taPrimary
    }
    
}
