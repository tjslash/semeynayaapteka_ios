//
//  FavoriteRepository.swift
//  TvoyaApteka
//
//  Created by BuidMac on 31.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

protocol FavoriteStrategy: FavoriteRepositoryType {
    
}

class FavoriteRepository: FavoriteRepositoryType {
    
    private let localStorage: FavoriteStorageProtocol
    private let authManager: AuthManager
    
    init(localStorage: FavoriteStorageProtocol, authManager: AuthManager) {
        self.localStorage = localStorage
        self.authManager = authManager
    }
    
    func add(id: Int) -> Completable {
        return getReciveStatrgy().add(id: id)
    }
    
    func get(count: Int, offset: Int, for userCity: City) -> Single<[Drug]> {
        return getReciveStatrgy().get(count: count, offset: offset, for: userCity)
    }
    
    func delete(id: Int) -> Completable {
        return getReciveStatrgy().delete(id: id)
    }
    
    func isExists(userCity: City, id: Int) -> Single<Bool> {
        return getReciveStatrgy().isExists(userCity: userCity, id: id)
    }
    
    private func getReciveStatrgy() -> FavoriteStrategy {
        if let currentUser = authManager.currenUser {
            return AuthorizedReceivingStrategy(user: currentUser)
        }
        
        return NotAuthorizedReceivingStrategy(localStorage: localStorage)
    }
    
}
