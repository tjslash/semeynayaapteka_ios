//
//  StatusLabel.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 06/04/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class StatusLabel: Label {
    
    override func applyStyle() {
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.taPrimary.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.1
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.textColor = UIColor.taPrimary
        self.font = UIFont.smallText
        self.textAlignment = .center
    }
    
}
