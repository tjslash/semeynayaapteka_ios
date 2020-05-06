//
//  WarehouseInfo.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

struct WarehouseInfo {
    let id: Int
    let tradeCount: Int
}

extension WarehouseInfo: RemoteEntity {
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let tradeCount = json["in_stock"].int
            else { return nil }
        
        self.id = id
        self.tradeCount = tradeCount
    }
    
}
