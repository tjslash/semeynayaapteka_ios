//
//  City.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 15.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import SwiftyJSON

struct City: Codable {
    let id: Int
    let title: String
    let regionId: Int
}

extension City: RemoteEntity {
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let title = json["title"].string,
            let regionId = json["region_id"].int
            else { return nil }
        
        self.id = id
        self.title = title
        self.regionId = regionId
    }
    
}
