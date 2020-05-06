//
//  AuthManagerType.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthManagerType {
    var currenUser: AuthUserType? { get }
    
    func login(phone: String, password: String) -> Single<AuthUserType>
    func register(phone: String, password: String, passwordConfirm: String, smsCode: String) -> Single<AuthUserType>
    func logOut() -> Completable
    func requestSms(phone: String) -> Completable
    func restorePassword(phone: String, password: String, passwordConfirm: String, smsCode: String) -> Completable
    func validateUserInfo(phone: String, password: String, passwordConfirm: String) -> Completable
}
