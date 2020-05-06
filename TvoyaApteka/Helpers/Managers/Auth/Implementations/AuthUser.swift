//
//  AuthUser.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

final class AuthUser: Decodable, Encodable, AuthUserType {
    
    // MARK: Public
    weak var auth: AuthManager?
    var tokenService: AccessTokenService!
    
    private(set) var info: UserInfo {
        didSet {
            auth?.change(currentUser: self)
        }
    }

    // MARK: Private
    private var token: Token {
        didSet {
            auth?.change(currentUser: self)
        }
    }
    
    private let userService = ServerAPI.user
    
    init(info: UserInfo, token: Token) {
        self.info = info
        self.token = token
    }
    
    func update(userInfo: UserInfo?, passwordInfo: NewPasswordContainer?) -> Completable {
        return getToken()
            .flatMapCompletable({ [unowned self] token in
                return self.userService.updateUserInfo(token: token, userInfo: userInfo, passwordInfo: passwordInfo)
                    .do(onCompleted: { [unowned self] in
                        if let newInfo = userInfo {
                            self.info = newInfo
                        }
                    })
            })
    }
    
    func getToken() -> Single<String> {
        return Single<String>.create(subscribe: { [unowned self] singleObserver in
            self.tokenService.retrieve(token: self.token, then: { (newToken, error) in
                if let error = error {
                    singleObserver(.error(error))
                    return
                }
                
                if let newToken = newToken {
                    self.token = newToken
                    singleObserver(.success(newToken.getFullTokenString()))
                    return
                }
                
                singleObserver(.success(self.token.getFullTokenString()))
            })
            
            return Disposables.create()
        }).observeOn(MainScheduler.instance)
    }
    
    // MARK: Decodable, Encodable
    enum CodingKeys: String, CodingKey {
        case info
        case token
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.info = try values.decode(UserInfo.self, forKey: .info)
        self.token = try values.decode(Token.self, forKey: .token)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(info, forKey: .info)
        try container.encode(token, forKey: .token)
    }
    
}
