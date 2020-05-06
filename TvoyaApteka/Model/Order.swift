//
//  Order.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 15.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Order {
    enum State: Int {
        case inProgress = 1
        case approved = 2
        case done = 3
        case canceled = 4
        case paid = 5
    }
    
    let id: Int
    let state: Order.State
    let promocode: PromoCode?
    let createdDate: Date
    let payDate: Date?
    let totalPrice: Double
    let totalPriceWithPromo: Double?
    let drugs: [Drug]
    let drugstore: DrugStore
}

extension Order: RemoteEntity {
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let state = json["status"].int,
            let totalPrice = json["total_price"].double,
            let createdDate = json["created_at"]["date"].string?.toDate(withFormat: .jsonDateWithMs)
            else { return nil }
        
        self.id = id
        self.state = Order.State(rawValue: state) ?? .inProgress
        self.totalPrice = totalPrice
        self.createdDate = createdDate
        
        guard
            let store = DrugStore(json: json["drugstore"])
            else { return nil }
        self.drugstore = store
        
        self.drugs = json["drugs"].arrayValue.compactMap { Drug(json: $0) }
        
        self.payDate = json["pay_datetime"].string?.toDate(withFormat: .jsonDateWithMs)
        self.totalPriceWithPromo = json["total_price_with_promocode"].double
        self.promocode = PromoCode(json: json["promocode"])
    }
    
    var finalPrice: Double {
        if let priceWithPromo = totalPriceWithPromo {
            return priceWithPromo
        }
        
        return totalPrice
    }
    
}

extension Order.State {
    
    var description: String {
        switch self {
        case .inProgress: return "В работе"
        case .approved: return "Подтвержден"
        case .done: return "Выполнен"
        case .canceled: return "Отменен"
        case .paid: return "Оплачен"
        }
    }
    
    static var allStates: [Order.State] {
        return [.inProgress, .approved, .paid, .done, .canceled]
    }
    
}
