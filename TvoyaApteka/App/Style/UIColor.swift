//
//  UIColor.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 23/03/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static let taLightPrimary = UIColor(rgb: 0xB1DFE4)
    static let taPrimary = UIColor(fromHex: "#123ba3")!
    //static let taPrimary = UIColor(rgb: 0x00A7B0)
    //static let taDarkPrimary = UIColor(rgb: 0x009BA3)
    //static let taDarkestPrimary = UIColor(rgb: 0x0097A7)
    
    static let taLightRed = UIColor(rgb: 0xF45A63)
    static let taRed = UIColor(rgb: 0xF4333E)
    static let taOrange = UIColor(rgb: 0xF47333)
    static let taGreen = UIColor(rgb: 0x2BD258)
    
    static let taBlack = UIColor(rgb: 0x333333)
    //static let taDarkGray = UIColor(rgb: 0x727272)
    static let taGray = UIColor(rgb: 0x949494)
    static let taLightGray = UIColor(rgb: 0xD4D4D4)
    static let taAlmostWhite = UIColor(rgb: 0xF9F9F9)
    
}
