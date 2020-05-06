//
//  UserService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 02.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxSwift

class UserAPI: UserAPIProtocol {
    
    private let adapter = NetworkAdapter<UserRequest>()

    //Регистрация
    func validateUserInfo(phone: String, password: String, passwordConfirm: String) -> Completable {
        let request = UserRequest.validateUser(phone: phone, password: password, passwordConfirm: passwordConfirm)
        return adapter.send(request: request)
            .asCompletable()
    }
    
    func registerUser(phone: String, password: String, passwordConfirm: String, smsCode: String) -> Single<Token> {
        let request = UserRequest.registerUser(phone: phone, password: password, passwordConfirm: passwordConfirm, smsCode: smsCode)
        return adapter.send(request: request)
            .mapObject(to: Token.self, keyPath: "data")
    }
    
    func requestSms(phone: String) -> Completable {
        let request = UserRequest.sendSms(phone: phone)
        return adapter.send(request: request)
            .asCompletable()
    }
    
    func restorePassword(phone: String, password: String, passwordConfirm: String, smsCode: String) -> Completable {
        let request = UserRequest.passwordRestore(
            phone: phone,
            password: password,
            passwordConfirm: passwordConfirm,
            smsCode: smsCode)
        
        return adapter.send(request: request)
            .asCompletable()
    }
    
    func logIn(phone: String, password: String) -> Single<Token> {
        let request = UserRequest.logIn(phone: phone, password: password)
        return adapter.send(request: request)
            .mapObject(to: Token.self, keyPath: "data")
    }
    
    func updateToken(token: String) -> Single<Token?> {
        let request = UserRequest.updateToken(token: token)
        
        return adapter.send(request: request)
            .mapOptionalObject(to: Token.self, keyPath: "data")
            .catchError({ error in
                guard let serviceError = error as? ServiceError else {
                    return Single.error(error)
                }
                
                switch serviceError {
                case .jsonParseFail:
                    return Single.just(nil)
                default:
                    return Single.error(error)
                }
            })
    }
    
    func logOut(token: String) -> Completable {
        let request = UserRequest.logOut(token: token)
        return adapter.send(request: request)
            .asCompletable()
    }
    
    func getUser(token: String) -> Single<UserInfo> {
        return adapter.send(request: .getUser(token: token))
            .mapObject(to: UserInfo.self, keyPath: "data")
    }
    
    func updateUserInfo(token: String, userInfo: UserInfo?, passwordInfo: NewPasswordContainer?) -> Completable {
        let request = UserRequest.updateUserInfo(token: token, userInfo: userInfo, passwordInfo: passwordInfo)
        return adapter.send(request: request)
            .asCompletable()
    }
    
    func changePassword(token: String, oldPassword: String, newPassword: String, newPasswordConfirm: String) -> Completable {
        let request = UserRequest.changePassword(
            token: token,
            oldPassword: oldPassword,
            newPassword: newPassword,
            newPasswordConfirm: newPasswordConfirm)
        
        return adapter.send(request: request)
            .asCompletable()
    }
    
}
