//
//  FavoriteRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

enum FavoriteRequest {
    case getFavorite(token: String, userCity: Int, offset: Int, limit: Int?)
    case addToFavorite(token: String, drugId: Int)
    case deleteFromFavorite(token: String, drugId: Int)
}

// MARK: - TargetType Protocol Implementation
extension FavoriteRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .getFavorite: return "/api/user/favourites"
        case let .addToFavorite(_, id): return "/api/user/favourites/\(id)"
        case let .deleteFromFavorite(_, id): return "/api/user/favourites/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFavorite: return .get
        case .addToFavorite: return .post
        case .deleteFromFavorite: return .delete
        }
    }
    
    var task: Task {
        switch self {
        case let .getFavorite(_, cityId, offset, limit):
            var parameters: [String: Any] = [:]
            
            parameters["city_id"] = cityId
            
            if let limit = limit {
                parameters["offset"] = offset
                parameters["limit"] = limit
            }
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .addToFavorite, .deleteFromFavorite:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getFavorite, .addToFavorite, .deleteFromFavorite: return "".toData()
        }
    }
    
    var headers: [String: String]? {
        var header: [String: String] = ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
        
        switch self {
        case let .getFavorite(token, _, _, _):
            header["Authorization"] = token
            
        case let .addToFavorite(token, _):
            header["Authorization"] = token
            
        case let .deleteFromFavorite(token, _):
            header["Authorization"] = token
        }
        
        return header
    }
}
