//
//  AuthManager.swift
//  TvoyaApteka
//
//  Created by BuidMac on 31.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class AuthManager: AuthManagerType {
    
    // MARK: Public
    
    static public let shared: AuthManager = {
        let userService = ServerAPI.user
        let manager = AuthManager(userService: userService)
        return manager
    }()
    
    private let tokenService: AccessTokenService
    
    private(set) var currenUser: AuthUserType? {
        get {
            if _currenUser == nil {
                let user = getCurrentUserFromKeychain()
                user?.auth = self
                user?.tokenService = tokenService
                _currenUser = user
            }
            
            return _currenUser
        }
        set(newUser) {
            guard let newUser = newUser as? AuthUser else {
                deleteCurrentUser()
                _currenUser = nil
                return
            }
            
            save(currentUser: newUser)
            newUser.auth = self
            newUser.tokenService = AccessTokenService(userService: ServerAPI.user)
            _currenUser = newUser
        }
    }
    
    // MARK: Private
    private var _currenUser: AuthUser?
    private let keychain = AuthKeychain()
    private let userService: UserAPIProtocol
    
    // MARK: Init
    
    init(userService: UserAPIProtocol) {
        self.userService = userService
        self.tokenService = AccessTokenService(userService: ServerAPI.user)
        setupKeychain()
    }
    
    // MARK: Public metods
    
    func login(phone: String, password: String) -> Single<AuthUserType> {
        return userService.logIn(phone: phone, password: password)
            .flatMap({ [unowned self] token in
                return self.getUserFromServerBy(token: token)
            })
    }
    
    func register(phone: String, password: String, passwordConfirm: String, smsCode: String) -> Single<AuthUserType> {
        return userService.registerUser(phone: phone, password: password, passwordConfirm: passwordConfirm, smsCode: smsCode)
            .flatMap({ [unowned self] token in
                return self.getUserFromServerBy(token: token)
            })
    }
    
    func logOut() -> Completable {
        guard let user = currenUser else {
            return Completable.empty()
        }
        
        return user.getToken()
            .flatMapCompletable({ [unowned self] token in
                self.userService.logOut(token: token)
            })
            .catchError({ error -> Completable in
                print("Error: \(error)")
                return Completable.empty()
            })
            .do(onCompleted: { [unowned self] in
                self.currenUser = nil
            })
    }
    
    func requestSms(phone: String) -> Completable {
        return userService.requestSms(phone: phone)
    }
    
    func restorePassword(phone: String, password: String, passwordConfirm: String, smsCode: String) -> Completable {
        return userService.restorePassword(phone: phone, password: password, passwordConfirm: passwordConfirm, smsCode: smsCode)
    }
    
    func validateUserInfo(phone: String, password: String, passwordConfirm: String) -> Completable {
        return userService.validateUserInfo(phone: phone, password: password, passwordConfirm: passwordConfirm)
    }
    
    // MARK: Private metods
    
    private func setupKeychain() {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "TvoyaApteka"
        let key = appName + "AuthManagerInstall"
        
        if UserDefaults.standard.object(forKey: key) == nil {
            keychain.removeUser()
            UserDefaults.standard.set(false, forKey: key)
        }
    }
    
    private func getUserFromServerBy(token: Token) -> Single<AuthUserType> {
        return self.userService.getUser(token: token.getFullTokenString())
            .map({ user in
                return AuthUser(info: user, token: token)
            })
            .do(onSuccess: { [unowned self] user in
                self.currenUser = user
            })
    }
    
}

// MARK: Current user related methods
extension AuthManager {
    
    func change(currentUser user: AuthUser) {
        keychain.set(user: user)
    }
    
    private func save(currentUser user: AuthUser) {
        keychain.set(user: user)
    }
    
    private func getCurrentUserFromKeychain() -> AuthUser? {
        return keychain.getUser()
    }
    
    private func deleteCurrentUser() {
        keychain.removeUser()
    }
    
}
