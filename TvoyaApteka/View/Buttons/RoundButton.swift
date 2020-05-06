//
//  RoundButton.swift
//  TvoyaApteka
//
//  Created by BuidMac on 03.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class RoundButton: Button {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height * 0.5
    }
    
}
