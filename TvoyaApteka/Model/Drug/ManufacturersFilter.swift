//
//  ManufacturersFilter.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 15.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

class ManufacturersAndPrice: RemoteEntity {
    
    let maxPrice: Double
    let minPrice: Double
    let manufacturers: [Manufacturer]
    
    required init?(json: JSON) {
        self.minPrice = json["price"]["min"].doubleValue
        self.maxPrice = json["price"]["max"].doubleValue
        
        self.manufacturers = json["manufacturers"].arrayValue
            .compactMap { Manufacturer(json: $0) }
    }
}
