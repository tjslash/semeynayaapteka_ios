//
//  Parser.swift
//  TvoyaApteka
//
//  Created by BuidMac on 24.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

protocol RemoteEntity {
    init?(json: JSON)
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func mapObject<T: RemoteEntity>(to type: T.Type, keyPath: String? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            let json = try self.getJSON(from: response.data, keyPath: keyPath)
            
            if let object = type.init(json: json) {
                return Single.just(object)
            }
            
            return Single.error(ServiceError.jsonParseFail)
        }
    }
    
    func mapOptionalObject<T: RemoteEntity>(to type: T.Type, keyPath: String? = nil) -> Single<T?> {
        return flatMap { response -> Single<T?> in
            let json = try self.getJSON(from: response.data, keyPath: keyPath)
        
            let object = type.init(json: json)
            return Single.just(object)
        }
    }
    
    func mapArray<T: RemoteEntity>(to type: T.Type, keyPath: String? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            let json = try self.getJSON(from: response.data, keyPath: keyPath)
            
            if let jsonArray = json.array {
                let objectArray = jsonArray.compactMap({ type.init(json: $0) })
                return Single.just(objectArray)
            }
            
            return Single.error(ServiceError.jsonParseFail)
        }
    }
    
    private func getJSON(from data: Data, keyPath: String? = nil) throws -> JSON {
        var json = try JSON(data: data)
        
        if let keyPath = keyPath {
            json = json[keyPath]
        }
        
        return json
    }
    
}
