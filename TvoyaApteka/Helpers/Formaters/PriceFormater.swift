//
//  PriceFormater.swift
//  TvoyaApteka
//
//  Created by BuidMac on 10.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

class PriceFormater {
    
    private(set) var currentCost: String = ""
    private(set) var oldCost: String?
    private(set) var discount: String?
    
    init(price: Price) {
        self.currentCost = PriceFormater.decorated(price.currentCost)
        
        if let oldCost = price.oldCost {
            self.oldCost = PriceFormater.decorated(oldCost)
        }
        
        if let discount = price.discount {
            self.discount = getDiscountText(discount)
        }
    }
    
    /// Decorates current price
    ///
    /// - Parameter currency: currency label
    /// - Returns: String with price and currentcy, for example: "20,05 руб."
    static func decorated(_ value: Double, currency: String = "руб.") -> String {
        return "\(String(format: "%.2f", value)) \(currency)"
    }
    
    /// Discount text description
    private func getDiscountText(_ discount: Price.DiscountType) -> String? {
        switch discount {
        case .percent(let value):
            let intVar: Int = Int(value * 10)
            let whole = intVar / 10
            let part = intVar % 10
            if part == 0 {
                return "\(whole)%"
            } else {
                return "\(whole),\(part)%"
            }
        case .cents(let value):
            return PriceFormater.decorated(value)
        }
    }
    
}
