//
//  DrugStoreRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

enum DrugStoreRequest {
    case getAllDrugStores(inCity: Int)
    case getDrugStore(storeId: Int)
}

// MARK: - TargetType Protocol Implementation
extension DrugStoreRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .getAllDrugStores: return "/api/drugstores/"
        case let .getDrugStore(storeId): return "/api/drugstores/\(storeId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllDrugStores, .getDrugStore: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getDrugStore: return .requestPlain
        case let .getAllDrugStores(inCity):
            return .requestParameters(
                parameters: ["city_id": inCity],
                encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getAllDrugStores, .getDrugStore: return "".toData()
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
    }
}
