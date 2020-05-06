//
//  Actual.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 07.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ActualCategory {
    let id: Int
    let title: String
}

extension ActualCategory: RemoteEntity {
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let title = json["title"].string
            else { return nil }
        
        self.id = id
        self.title = title
    }
    
}
