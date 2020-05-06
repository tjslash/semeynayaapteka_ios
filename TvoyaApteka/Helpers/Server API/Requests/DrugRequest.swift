//
//  DrugRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

enum DrugRequest {
    case search(query: String, inCity: Int, from: Int, count: Int)
    case getDrugShortCards(inCategory: Int, inCity: Int, from: Int, count: Int, filter: DrugFilter?)
    case getDrug(inCity: Int, drugId: Int)
    case getManufacturers(inCity: Int)
}

// MARK: - TargetType Protocol Implementation
extension DrugRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .search: return "/api/catalog/search"
        case let .getDrugShortCards(inCategory, _, _, _, _): return "/api/catalog/\(inCategory)/"
        case let .getDrug(_, drugId): return "/api/drugs/\(drugId)/"
        case .getManufacturers: return "/api/filters/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search,
             .getDrugShortCards,
             .getDrug,
             .getManufacturers: return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .search(query, inCity, from, count):
            var dictionary: [String: Any] = [:]
            dictionary["q"] = query
            dictionary["city_id"] = inCity
            dictionary["offset"] = from
            dictionary["limit"] = count
            
            return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
            
        case let .getDrugShortCards(_, inCity, from, count, filter):
            
            var dictionary = createFilterDictionary(filter: filter)
            
            dictionary["city_id"] = inCity
            dictionary["offset"] = from
            dictionary["limit"] = count
            
            return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
            
        case let .getDrug(inCity, _):
            return .requestParameters(
                parameters: ["city_id": inCity],
                encoding: URLEncoding.queryString)
            
        case let .getManufacturers(inCity):
            return .requestParameters(
                parameters: ["city_id": inCity],
                encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .search,
             .getDrugShortCards,
             .getDrug,
             .getManufacturers: return "".toData()
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
    }
    
    func createFilterDictionary(filter: DrugFilter?) -> [String: Any] {
        var dictionary = [String: Any]()
        if let filter = filter {
            if let sales = filter.sales {
                dictionary["sales"] = sales
            }
            
            if let hit = filter.hit {
                dictionary["hit"] = hit
            }
            
            let manufacturersIds = filter.manufacturers.map({"\($0)"}).joined(separator: ",")
            if manufacturersIds.count > 0 {
                dictionary["manufacturers"] = manufacturersIds
            }
            
            if let priceMin = filter.priceMin {
                dictionary["price_min"] = priceMin
            }
            
            if let priceMax = filter.priceMax {
                dictionary["price_max"] = priceMax
            }
            
            if let order = filter.order {
                dictionary["order"] = order.rawValue
            }
            
            if let sort = filter.sort {
                dictionary["sort"] = sort.rawValue
            }
        }
        return dictionary
    }
}
