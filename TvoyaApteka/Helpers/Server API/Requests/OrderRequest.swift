//
//  OrderRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

enum OrderRequest {
    case getOrders(token: String, orderStatus: Int?)
    case getOrder(token: String, orderId: Int)
    case cancelOrder(token: String, orderId: Int)
    case createOrderFromCart(token: String, promocode: String?)
}

// MARK: - TargetType Protocol Implementation
extension OrderRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .getOrders: return "/api/orders"
        case .createOrderFromCart: return "/api/orders"
        case let .getOrder(_, orderId): return "/api/orders/\(orderId)"
        case let .cancelOrder(_, orderId): return "/api/orders/\(orderId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .cancelOrder,
             .createOrderFromCart: return .post
        case .getOrder,
             .getOrders: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getOrder,
             .cancelOrder:
            return .requestPlain
            
        case let .getOrders(_, orderStatus):
            if let status = orderStatus {
                return .requestParameters(
                    parameters: [
                    "status": status,
                    "offset": 0,
                    "limit": 1000
                    ],
                    encoding: URLEncoding.default)
            } else {
                return .requestParameters(
                    parameters: [
                        "offset": 0,
                        "limit": 1000
                    ],
                    encoding: URLEncoding.default)
            }
            
        case let .createOrderFromCart(_, promocode):
            if let promo = promocode {
                return .requestParameters(
                    parameters: ["promocode": promo],
                    encoding: JSONEncoding.default)
            } else {
                return .requestPlain
            }
            
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getOrders,
             .getOrder,
             .cancelOrder,
             .createOrderFromCart:
            return "".toData()
        }
    }
    
    var headers: [String: String]? {
        
        var header: [String: String] = ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
        
        switch self {
        case let .getOrders(token, _):
            header["Authorization"] = token
            
        case let .getOrder(token, _):
            header["Authorization"] = token
            
        case let .cancelOrder(token, _):
            header["Authorization"] = token
            
        case let .createOrderFromCart(token, _):
            header["Authorization"] = token
        }
        
        return header
    }
}
