//
//  AuthKeychain.swift
//  TvoyaApteka
//
//  Created by BuidMac on 16.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import KeychainSwift

class AuthKeychain {
 
    private let keychain = KeychainSwift()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let userKey: String
    
    init() {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "TvoyaApteka"
        self.userKey = appName + "authUser"
    }
    
    func getUser() -> AuthUser? {
        guard let data = keychain.getData(userKey) else { return nil }
        
        // swiftlint:disable force_try
        return try! decoder.decode(AuthUser.self, from: data)
        // swiftlint:enable force_try
    }
    
    func set(user: AuthUser) {
        // swiftlint:disable force_try
        let data = try! encoder.encode(user)
        // swiftlint:enable force_try
        
        keychain.set(data, forKey: userKey)
    }
    
    func removeUser() {
        keychain.delete(userKey)
    }
    
}
