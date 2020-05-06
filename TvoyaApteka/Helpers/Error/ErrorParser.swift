//
//  ErrorParser.swift
//  TvoyaApteka
//
//  Created by BuidMac on 19.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import Log
import SwiftyJSON

class ErrorParser {
    
    static private let log = Logger(formatter: .minimal)
    
    static func parse(from errorData: Data, code: Int) -> ServiceError {
        log.warning("ServerErrorCode: \(code)")
        log.warning("ServerErrorData: \(errorData.toString())")
        
        switch code {
        case 401:
            return ServiceError.notAuthorized(message: parse(from: errorData))
        case 403:
            return ServiceError.alreadyUsed(message: parse(from: errorData))
        case 404:
            return ServiceError.notFound(message: parse(from: errorData))
        case 422:
            return ServiceError.validation(message: parse(from: errorData))
        case 500:
            return ServiceError.serverError(message: parse(from: errorData))
        case 503:
            return ServiceError.serverError(message: parse(from: errorData))
        default:
            return ServiceError.unexpectedServerCode
        }
        
    }
    
    static func parse(from data: Data) -> ServerBagErrors {
        guard let json = try? JSON(data: data), let dictionary = json["errors"].dictionaryObject else {
            return ServerBagErrors.empty()
        }
        
        var errors: [ServerError] = []
        
        for item in dictionary {
            guard let type = ServerError.ErrorType(rawValue: item.key) else {
                print("Error: type '\(item.key)' is not recognized while parse json error")
                continue
            }
            
            if let descriptions = item.value as? String {
                errors.append(ServerError(type: type, objectId: nil, description: descriptions))
                continue
            }
            
            if let descriptions = item.value as? [String] {
                errors += descriptions.map({ ServerError(type: type, objectId: nil, description: $0) })
                continue
            }
            
            if let descriptions = item.value as? [String: String] {
                errors += descriptions.map({ ServerError(type: type, objectId: $0.key, description: $0.value) })
                continue
            }
        }
        
        return ServerBagErrors(message: nil, errors: errors)
    }
    
    static private func getFirstErrorDescription(from bag: ServerBagErrors) -> String? {
        return bag.errors.first?.description
    }
    
}
