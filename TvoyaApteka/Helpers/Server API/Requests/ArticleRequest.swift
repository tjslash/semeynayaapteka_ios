//
//  ArticleRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

enum ArticleRequest {
    case articlesList(from: Int, count: Int)
    case article(inCity: Int, id: Int)
}

// MARK: - TargetType Protocol Implementation
extension ArticleRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .articlesList: return "/api/articles"
        case let .article(_, id): return "/api/articles/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .articlesList, .article: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .articlesList(let from, let count):
            return .requestParameters(
                parameters: [
                    "offset": from,
                    "limit": count],
                encoding: URLEncoding.queryString)
            
        case let .article(inCity, _):
            return .requestParameters(
                parameters: ["city_id": inCity],
                encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .articlesList, .article: return "".toData()
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
    }
}
