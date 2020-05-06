//
//  PromoRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

enum PromoRequest {
    case getPromotionList(inCity: Int, from: Int, count: Int)
    case promo(inCity: Int, id: Int)
}

// MARK: - TargetType Protocol Implementation
extension PromoRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .getPromotionList: return "/api/promotions"
        case let .promo(_, id): return "/api/promotions/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPromotionList, .promo: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPromotionList(let inCity, let from, let count):
            return .requestParameters(
                parameters: [
                    "city_id": inCity,
                    "offset": from,
                    "limit": count
                ],
                encoding: URLEncoding.queryString)
            
        case let .promo(inCity, _):
            return .requestParameters(
                parameters: ["city_id": inCity],
                encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getPromotionList, .promo: return "".toData()
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
    }
}
