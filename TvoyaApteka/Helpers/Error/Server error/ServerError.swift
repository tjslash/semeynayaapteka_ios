//
//  ServerError.swift
//  TvoyaApteka
//
//  Created by BuidMac on 20.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

struct ServerError: Error {
    
    enum ErrorType: String {
        case token
        case phone
        case password
        case smsCode = "sms_code"
        case authorization = "Authentication failed"
        case server
        case oldPassword = "old_password"
        case promocode
        case cart
        case card
        case name
        case drugs
        case drugstores
    }
    
    let type: ServerError.ErrorType
    let objectId: String?
    let description: String
}

extension ServerError {
    
    var debugDescription: String {
        fatalError()
    }
    
}

extension Array where Element == ServerError {
    
    var firstMessage: String? {
        return self.first?.description
    }
    
}
