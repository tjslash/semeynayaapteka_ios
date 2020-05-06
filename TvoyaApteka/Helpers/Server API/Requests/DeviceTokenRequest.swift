//
//  DeviceTokenRequest.swift
//  TvoyaApteka
//
//  Created by BuidMac on 16.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import Moya

enum DeviceTokenRequest {
    case send(token: String, pushToken: String)
}

// MARK: - TargetType Protocol Implementation
extension DeviceTokenRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .send:
            return "/api/device-token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .send:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .send(_, let pushToken):
            var params: [String: String] = [:]
            params["value"] = pushToken
            params["platform"] = "ios"
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .send:
            return "".toData()
        }
    }
    
    var headers: [String: String]? {
        var header: [String: String] = ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
        
        switch self {
        case let .send(token, _):
            header["Authorization"] = token
        }
        
        return header
    }
}
