//
//  Promotion.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

class Promotion: RemoteImage, RemoteEntity {
    
    let id: Int
    let title: String
    let text: String
    let startDate: Date?
    let endDate: Date?
    let images: [String]
    let cityId: Int?
    let url: String
    let drugs: [Drug]
    
    required init?(json: JSON) {
        guard
            let id = json["id"].int,
            let title = json["title"].string,
            let text = json["text"].string,
            let url = json["url"].string
            else { return nil }
        
        self.id = id
        self.title = title
        self.text = text
        self.url = url
        
        self.startDate = json["start_datetime"].string?.toDate(withFormat: .jsonDate)
        self.endDate = json["end_datetime"].string?.toDate(withFormat: .jsonDate)
        self.images = json["images"].array?.compactMap { $0.string } ?? []
        self.cityId = json["city_id"].int
        self.drugs = json["drugs"].arrayValue.compactMap { Drug(json: $0) }
    }
}
