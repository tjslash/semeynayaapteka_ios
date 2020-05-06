//
//  AdressLabel.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 30/03/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

@IBDesignable
public class AdressLabel: Label {
    
    override public func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.taGray.cgColor
        super.draw(rect)
    }
    
    override public func drawText(in rect: CGRect) {
        self.textColor = UIColor.taGray
        self.font = UIFont.normalText
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
}
