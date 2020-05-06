//
//  PromoCode.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PromoCode {
    let code: String
    let type: String
    let amount: Int
    let isPercent: Bool
    
    init(code: String, type: String = "", amount: Int = 0, isPercent: Bool = false) {
        self.code = code
        self.type = type
        self.amount = amount
        self.isPercent = isPercent
    }
}

extension PromoCode: RemoteEntity {
    
    init?(json: JSON) {
        guard
            let code = json["code"].string,
            let type = json["type"].string,
            let amount = json["amount"].int,
            let isPercent = json["is_percent"].int
            else { return nil }
        
        self.code = code
        self.type = type
        self.amount = amount
        self.isPercent = isPercent == 0
    }
    
}
