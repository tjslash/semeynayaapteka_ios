//
//  CartRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

enum CartRequest {
    case getCart(token: String, cityId: Int, promocode: String?)
    case addToCart(token: String, drugStoreId: Int, drugId: Int, count: Int)
    case deleteFromCart(drugStoreId: Int, drugId: Int, count: UInt)
    case deleteTradeFromCart(token: String, drugsId: [Int])
}

// MARK: - TargetType Protocol Implementation
extension CartRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .getCart,
             .addToCart,
             .deleteTradeFromCart: return "/api/cart"
            
        case .deleteFromCart:  return "/api/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCart:
            return .get
            
        case .addToCart:
            return .post
            
        case .deleteTradeFromCart:
            return .delete
            
        case .deleteFromCart:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .getCart(_, cityId, promocode):
            var parameters: [String: Any] = [:]
            parameters["city_id"] = cityId
            
            if let promocode = promocode {
                parameters["promocode"] = promocode
            }
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case let .addToCart(_, drugStoreId, drugId, count):
            
            var subDictionary: [String: Int] = [:]
            subDictionary["drug_id"] = drugId
            subDictionary["count"] = count
            subDictionary["drugstore_id"] = drugStoreId
            
            return .requestParameters(
                parameters: ["cart": [subDictionary]],
                encoding: JSONEncoding.default)
            
        case let .deleteFromCart(drugStoreId, drugId, count):
            return .requestParameters(
                parameters: [
                    "drugStoreId": drugStoreId,
                    "drugId": drugId,
                    "count": count
                ],
                encoding: JSONEncoding.default)
            
        case let .deleteTradeFromCart(_, drugsId):
            return .requestParameters(
                parameters: ["drugs": drugsId],
                encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getCart,
             .addToCart,
             .deleteFromCart,
             .deleteTradeFromCart:
            return "".toData()
        }
    }
    
    var headers: [String: String]? {
        
        var header: [String: String] = ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]

        switch self {
        case let .getCart(token, _, _):
            header["Authorization"] = token
            
        case let .deleteTradeFromCart(token, _):
            header["Authorization"] = token
            
        case let .addToCart(token, _, _, _):
            header["Authorization"] = token
        default: break
        }
        
        switch self {
        case .addToCart:
            header["Content-Type"] = "application/json"
        default: break
        }
        
        return header
    }
}
