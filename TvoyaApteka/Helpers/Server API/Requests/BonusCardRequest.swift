//
//  BonusCardRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

enum BonusCardRequest {
    case getBonusCard(token: String)
    case activateBonusCard(token: String, cardNum: String)
}

// MARK: - TargetType Protocol Implementation
extension BonusCardRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .getBonusCard: return "/api/user/bonus-card"
        case let .activateBonusCard(_, cardNum): return "/api/user/bonus-card/\(cardNum)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBonusCard:
            return .get
        case .activateBonusCard:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .activateBonusCard(_, cardNum):
            return .requestParameters(
                parameters: [
                    "cardNum": cardNum
                ],
                encoding: JSONEncoding.default)
            
        case .getBonusCard:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .activateBonusCard,
             .getBonusCard: return "".toData()
        }
    }
    
    var headers: [String: String]? {
        var header: [String: String] = ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
        
        switch self {
        case let .getBonusCard(token):
            header["Authorization"] = token
            
        case let .activateBonusCard(token, _):
            header["Authorization"] = token
        }
        
        return header
    }
}
