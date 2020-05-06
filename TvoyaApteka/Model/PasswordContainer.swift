//
//  PasswordContainer.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PasswordContainer {
    let phone: String
    let password: String
    let passwordConfirm: String
    
    init(phone: String, password: String, passwordConfirm: String) {
        self.phone = phone
        self.password = password
        self.passwordConfirm = passwordConfirm
    }
}
