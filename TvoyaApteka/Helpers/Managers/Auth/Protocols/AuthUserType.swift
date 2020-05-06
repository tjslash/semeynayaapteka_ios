//
//  AuthUserType.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthUserType {
    var info: UserInfo { get }
    
    func update(userInfo: UserInfo?, passwordInfo: NewPasswordContainer?) -> Completable
    func getToken() -> Single<String>
}
