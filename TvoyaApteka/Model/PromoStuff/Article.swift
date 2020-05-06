//
//  Article.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

class Article: RemoteImage, RemoteEntity {
    
    let id: Int
    let title: String
    let date: Date
    let announce: String
    let images: [String]
    let content: String
    let drugs: [Drug]
    
    required init?(json: JSON) {
        guard
            let id = json["id"].int,
            let title = json["title"].string,
            let dateCreated = json["created_at"]["date"].string?.toDate(withFormat: .jsonDateWithMs)
            else { return nil }
        
        self.id = id
        self.title = title
        self.date = dateCreated
        self.announce = json["announce"].stringValue
        self.images = json["images"].arrayValue.compactMap { $0.string }
        self.content = json["content"].stringValue
        self.drugs = json["drugs"].arrayValue.compactMap { Drug(json: $0) }
    }
}
