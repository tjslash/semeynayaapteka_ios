//
//  Manufacturer.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Manufacturer: RemoteEntity {
    let id: Int
    let title: String
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let title = json["title"].string
            else { return nil }
        
        self.id = id
        self.title = title
    }
}
