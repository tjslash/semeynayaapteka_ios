//
//  OrderDetailsCellModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

class OrderDetailsCellModel {
    
    let order: Order
    let numberText: String
    let statusText: String
    let createdDateText: String
    let createdWeekdayText: String
    let drugStoreNameText: String
    let drugStoreAddressText: String
    let totalCostString: String
    
    init(order: Order) {
        self.order = order
        self.numberText = "Заказ № \(order.id)"
        self.statusText = order.state.description.uppercased()
        self.createdDateText = order.createdDate.dayOfWeek() ?? ""
        self.createdWeekdayText = "(\(order.createdDate.toString(withFormat: .dateShortDottedText)))"
        self.drugStoreNameText = order.drugstore.title + ","
        self.drugStoreAddressText = order.drugstore.address
        self.totalCostString = PriceFormater.decorated(order.finalPrice)
    }
    
}
