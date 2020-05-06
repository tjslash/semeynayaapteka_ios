//
//  DrugOrderCellModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

class DrugOrderCellModel {
    
    let drug: Drug
    let titleText: String
    let countStatusText: String
    let drugImageUrl: URL?
    let countText: String
    let currentCostText: String
    private(set) var oldCostText: String?
    private(set) var discountText: String?
    
    init(drug: Drug) {
        self.drug = drug
        self.titleText = drug.title
        self.countStatusText = "В наличии"
        self.drugImageUrl = drug.getMainImageUrl()
        self.countText = "\(drug.count ?? 0) шт."
        
        if let price = drug.price {
            let priceFormater = PriceFormater(price: price)
            self.currentCostText = priceFormater.currentCost
            self.oldCostText = priceFormater.oldCost
            self.discountText = priceFormater.discount
        } else {
            self.currentCostText = ""
        }
    }
    
}
