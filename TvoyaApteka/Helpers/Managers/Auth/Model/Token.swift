//
//  Token.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Token: Codable, RemoteEntity {
    
    let mainString: String
    let type: String
    let expiresIn: TimeInterval
    
    private let seconds: Double = 10.0
    
    var isExpires: Bool {
        return Date.timeIntervalSinceReferenceDate >= (expiresIn - seconds)
    }
    
    var isValid: Bool {
        return isExpires == false
    }
    
    init(mainString: String, type: String, expiresIn: TimeInterval) {
        self.mainString = mainString
        self.type = type
        self.expiresIn = expiresIn
    }
    
    init?(json: JSON) {
        guard let mainString = json["access_token"].string else { return nil }
        guard let type = json["token_type"].string else { return nil }
        guard let expiresInSecondAfterCreated = json["expires_in"].double else { return nil }
        
        self.mainString = mainString
        self.type = type
        self.expiresIn = Date.timeIntervalSinceReferenceDate + expiresInSecondAfterCreated
    }
    
    func getFullTokenString() -> String {
        return type + " " + mainString
    }

}
