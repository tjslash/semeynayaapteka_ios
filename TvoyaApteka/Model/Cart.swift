//
//  Cart.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 28.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import SwiftyJSON

class Cart: RemoteEntity {
    
    struct Item {
        let drug: Drug
        let count: Int
        let drugstoreId: Int
        let prices: Price
    }
    
    var items: [Item]
    let totalPrice: Double
    let totalPriceWithPromo: Double
    var promocode: PromoCode?
    
    init() {
        self.items = []
        self.totalPrice = 0.0
        self.totalPriceWithPromo = 0.0
        self.promocode = nil
    }
    
    required init?(json: JSON) {
        self.totalPrice = json["order_price"].double ?? 0.0
        self.totalPriceWithPromo = json["order_price_with_promocode"].double ?? 0.0
        
        self.promocode = PromoCode(json: json["promocode"])
        
        self.items = json["items"].arrayValue.compactMap { Cart.Item(json: $0) } 
    }
    
}

extension Cart {
    
    var isEmpty: Bool {
        return items.count == 0
    }
    
    var hasStrictRecipeTrades: Bool {
        for trade in items where trade.drug.recipeType == .strictlyRecipe {
            return true
        }
        return false
    }
    
    var hasDiscount: Bool {
        return totalPrice != totalPriceWithPromo
    }
    
}

extension Cart.Item: RemoteEntity {
    
    init?(json: JSON) {
        guard
            let count = json["count"].int,
            let drugstoreId = json["drugstore_id"].int
            else { return nil }
        
        self.count = count
        self.drugstoreId = drugstoreId
        
        guard
            let drug = Drug(json: json["drug"])
            else { return nil }
        self.drug = drug
        
        guard
            let prices = Price(json: json["prices"])
            else { return nil }
        self.prices = prices
        self.drug.price = prices
    }
    
}
