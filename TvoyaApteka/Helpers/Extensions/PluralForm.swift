//
//  PluralForm.swift
//  TvoyaAptekaInterface
//
//  Created by BuidMac on 01.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

extension Int {
    
    func pluralForm(form1: String, form2: String, form5: String) -> String {
        let num = abs(self) % 100
        let num1 = num % 10
        if num > 10 && num < 20 { return form5 }
        if num1 > 1 && num1 < 5 { return form2 }
        if num1 == 1 { return form1 }
        return form5
    }
    
}
