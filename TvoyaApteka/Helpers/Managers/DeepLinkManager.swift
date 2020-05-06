//
//  DeepLinkManager.swift
//  TvoyaApteka
//
//  Created by BuidMac on 16.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

public enum DeepLinkOption {
    case deals
    case order(id: Int)
}

public class DeepLinkManager {
    
    private static let promotions = "PROMOTIONS"
    private static let order = "ORDER_STATUS"
    
    static func build(with dict: [String: AnyObject]?) -> DeepLinkOption? {
        guard let type = dict?["type"] as? String else { return nil }
        
        switch type {
        case promotions:
            return DeepLinkOption.deals
        case order:
            guard let id = dict?["order_id"] as? Int else { return nil }
            return DeepLinkOption.order(id: id)
        default: return nil
        }
    }
    
}
