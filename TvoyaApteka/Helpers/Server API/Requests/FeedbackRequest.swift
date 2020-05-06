//
//  FeedbackRequest.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 05.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Moya

enum FeedbackRequest {
    case sendFeedback(phone: String, text: String, name: String)
}

// MARK: - TargetType Protocol Implementation
extension FeedbackRequest: TargetType {
    
    var baseURL: URL { return Const.Url.server }
    
    var path: String {
        switch self {
        case .sendFeedback: return "/api/feedback"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendFeedback:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .sendFeedback(phone, text, name):
            return .requestParameters(
                parameters: [
                    "phone": phone,
                    "text": text,
                    "name": name
                ],
                encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .sendFeedback:
            return "".toData()
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/vnd.tvoyaapteka.v1.api+json"]
    }
}
