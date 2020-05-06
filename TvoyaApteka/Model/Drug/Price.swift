//
//  DrugPrice.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 14.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Price {
    
    enum DiscountType {
        case percent(value: Double)
        case cents(value: Double)
    }
    
    let currentCost: Double
    let oldCost: Double?
    let discount: DiscountType?
    
    init(currentCost: Double, oldCost: Double? = nil, discount: DiscountType? = nil) {
        self.currentCost = currentCost
        self.oldCost = oldCost
        self.discount = discount
    }
    
    fileprivate init(_ price: Price) {
        self.currentCost = price.currentCost
        self.oldCost = price.oldCost
        self.discount = price.discount
    }
    
}

extension Price: RemoteEntity {
    
    init?(json: JSON) {
        guard
            let baseDoublePrice = json["price"].double,
            let discountInPercent = json["discount_is_percent"].bool
            else { return nil }
        
        let innerDiscount = json["discount"].double
        
        let price = PriceHelper.make(baseDoublePrice: baseDoublePrice, discountInPercent: discountInPercent, innerDiscount: innerDiscount)
        self.init(price)
    }
}

class PriceHelper {
    
    static func make(baseDoublePrice: Double, discountInPercent: Bool, innerDiscount: Double?) -> Price {
        if let discount = innerDiscount {
            if discount == 0 {
                return Price(currentCost: baseDoublePrice)
            } else {
                if discountInPercent {
                    let discount = Price.DiscountType.percent(value: discount)
                    let costWithDisctount = PriceHelper.apply(discoun: discount, to: baseDoublePrice)
                    return Price(currentCost: costWithDisctount, oldCost: baseDoublePrice, discount: discount)
                } else {
                    let discount = Price.DiscountType.cents(value: discount)
                    let costWithDisctount = PriceHelper.apply(discoun: discount, to: baseDoublePrice)
                    return Price(currentCost: costWithDisctount, oldCost: baseDoublePrice, discount: discount)
                }
            }
        }
        
        return Price(currentCost: baseDoublePrice)
    }
    
    static private func apply(discoun: Price.DiscountType, to cost: Double) -> Double {
        switch discoun {
        case .percent(let percent):
            let centsDiscount = convertToCents(cost, percent)
            return cost - centsDiscount
        case .cents(let value): return cost + value
        }
    }
    
    static private func convertToCents(_ cost: Double, _ percent: Double) -> Double {
        return cost / 100 * percent
    }
    
}
