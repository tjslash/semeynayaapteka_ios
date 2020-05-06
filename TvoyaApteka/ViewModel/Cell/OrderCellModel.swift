//
//  OrderCellModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

class OrderCellModel {
    
    let order: Order
    let addressText: String
    let costText: String
    let stateText: String
    let orderNumberText: String
    
    init(order: Order) {
        self.order = order
        self.addressText = order.drugstore.title + ", " + order.drugstore.address
        self.costText = PriceFormater.decorated(order.finalPrice)
        self.stateText = order.state.description.uppercased()
        self.orderNumberText = "Заказ № \(order.id)"
    }
    
}
