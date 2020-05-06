//
//  ServerBagErrors.swift
//  TvoyaApteka
//
//  Created by BuidMac on 20.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

struct ServerBagErrors {
    
    let message: String?
    let errors: [ServerError]
    
    init(message: String? = nil, errors: [ServerError]) {
        self.message = message
        self.errors = errors
    }
    
    subscript(type: ServerError.ErrorType) -> [ServerError] {
        return errors.filter({ $0.type == type })
    }
    
    static func empty() -> ServerBagErrors {
        return ServerBagErrors(errors: [])
    }
    
}
