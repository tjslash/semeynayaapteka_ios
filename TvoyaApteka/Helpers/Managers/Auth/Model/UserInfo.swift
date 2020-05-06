//
//  User.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 15.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

struct UserInfo: Codable, RemoteEntity {
    var firstName: String?
    var lastName: String?
    var middleName: String?
    var email: String?
    let phoneNumber: String
    var receivePromo: Bool
    
    init(phoneNumber: String, receivePromo: Bool) {
        self.phoneNumber = phoneNumber
        self.receivePromo = receivePromo
    }
    
    init?(json: JSON) {
        guard
            let phone = json["phone"].string,
            let receivePromo = json["is_notify"].bool
            else { return nil }
        
        self.phoneNumber = phone
        self.receivePromo = receivePromo
        
        self.firstName = json["firstname"].string
        self.lastName = json["lastname"].string
        self.middleName = json["surname"].string
        self.email = json["email"].string
    }
    
}
