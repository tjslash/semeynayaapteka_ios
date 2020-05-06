//
//  InfoLabel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 28.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class InfoLabel: LabelWithPadding {

    override func applyStyle() {
        super.applyStyle()
        textAlignment = .center
        textColor = .taAlmostWhite
        backgroundColor = .taLightRed
        font = UIFont.Title.h5
        numberOfLines = 0
        contentInset = UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 4)
    }
    
}
