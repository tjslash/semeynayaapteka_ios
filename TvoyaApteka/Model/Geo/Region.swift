//
//  Region.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 15.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Region {
    let id: Int
    let title: String
    let cities: [City]
}

extension Region: RemoteEntity {
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let title = json["title"].string
            else { return nil }
        
        self.id = id
        self.title = title
        
        self.cities = json["cities"].arrayValue.compactMap { City(json: $0) }
    }
}
