//
//  String.swift
//  TvoyaApteka
//
//  Created by BuidMac on 01.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

extension String {
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
}
