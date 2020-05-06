//
//  DrugCategoriesRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

enum SortType: String {
    case price
    case title
}

enum OrderType: String {
    case asc
    case desc
}

enum DrugCategoriesRequest {
    case getAllCategories
}

// MARK: - TargetType Protocol Implementation
extension DrugCategoriesRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .getAllCategories: return "/api/catalog"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllCategories: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAllCategories: return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getAllCategories: return "".toData()
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
    }
}
