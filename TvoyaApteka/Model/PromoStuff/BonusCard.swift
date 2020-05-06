//
//  BonusCard.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 15.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BonusCard {
    let id: Int
    let cardNum: String
    let amount: Double
    let isActive: Bool?
    let activationDate: Date?
    let operations: [BonusOperation]
}

public class BonusOperation: RemoteEntity {
    let id: Int
    let drugStoreId: Int
    let amount: Double
    var date: Date
    
    required public init?(json: JSON) {
        guard
            let id = json["id"].int,
            let drugStoreId = json["drugstore_id"].int,
            let amount = json["amount"].double,
            let dateCreated = json["created_at"]["date"].string?.toDate(withFormat: .jsonDateWithMs)
            else { return nil }
        
        self.id = id
        self.drugStoreId = drugStoreId
        self.amount = amount
        self.date = dateCreated
    }
}

extension BonusCard: RemoteEntity {
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let cardNum = json["number"].string,
            let amount = json["amount"].double
            else { return nil }
        
        self.id = id
        self.cardNum = cardNum
        self.amount = amount
        self.isActive = json["is_active"].bool
        self.activationDate = (json["activation_date"].string ?? "").toDate(withFormat: .jsonDate)
        self.operations = json["bonus_logs"].arrayValue.compactMap { BonusOperation(json: $0) }
    }
}
