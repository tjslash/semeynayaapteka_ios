//
//  Drug.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

enum RecipeType: Int {
    case simple = 1
    case recipe = 2
    case strictlyRecipe = 3
}

class Drug: RemoteImage, RemoteEntity {
    
    let id: Int
    var recipeType: RecipeType
    let title: String
    let manufacturer: Manufacturer?
    let categoryId: Int?
    let rlcDescription: String?
    let images: [String]
    let molecularComposition: String?
    var price: Price?
    let drugstores: [WarehouseInfo]
    let count: Int? //Количество купленного товара. Приходит не во всех случаях!!
    private(set) var analogs: [Drug] = []
    private(set) var tooBuy: [Drug] = []
    
    required init?(json: JSON) {
        guard
            let id = json["id"].int,
            let type = json["type"].int,
            let title = json["title"].string
            else { return nil }
        
        self.id = id
        self.recipeType = RecipeType(rawValue: type) ?? .simple
        self.title = title
        self.manufacturer = Manufacturer(json: json["manufacturer"])
        self.rlcDescription = json["text"].string
        self.images = json["images"].array?.compactMap { $0.string } ?? []
        self.categoryId = json["category_id"].int
        self.molecularComposition = json["molecular_composition"].string
        self.count = json["count"].int

        self.price = Price(json: json["prices"])
        
        self.drugstores = json["drugstores"].arrayValue.compactMap { WarehouseInfo(json: $0) }
        self.analogs = json["analogs"].arrayValue.compactMap { Drug(json: $0) }
        self.tooBuy = json["too_buy"].arrayValue.compactMap { Drug(json: $0) }
    }
    
}
