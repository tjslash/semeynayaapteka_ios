//
//  ActualRequest.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 07.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Moya

enum ActualRequest {
    case actual(actualId: Int, cityId: Int, from: UInt, count: UInt)
    case actualList
}

extension ActualRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .actualList: return "/api/actuals"
        case let .actual(actualId, _, _, _): return "/api/actuals/\(actualId)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .actualList, .actual: return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .actual(_, cityId, from, count):
            return .requestParameters(
                parameters: [
                    "city_id": cityId,
                    "offset": from,
                    "limit": count],
                encoding: URLEncoding.queryString)
            
        case .actualList:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .actualList, .actual: return "".toData()
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
    }
}
