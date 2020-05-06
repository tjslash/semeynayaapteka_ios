//
//  CitiesRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

enum CitiesRequest {
    case getAllRegionsAndCities
}

// MARK: - TargetType Protocol Implementation
extension CitiesRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .getAllRegionsAndCities: return "api/regions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllRegionsAndCities: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAllRegionsAndCities:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getAllRegionsAndCities: return "".toData()
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
    }
}
