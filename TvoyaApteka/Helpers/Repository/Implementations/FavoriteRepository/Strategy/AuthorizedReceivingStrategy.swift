//
//  AuthorizedReceivingStrategy.swift
//  TvoyaApteka
//
//  Created by BuidMac on 20.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class AuthorizedReceivingStrategy: FavoriteStrategy {
    
    private let user: AuthUserType
    
    init(user: AuthUserType) {
        self.user = user
    }
    
    func add(id: Int) -> Completable {
        return user.getToken()
            .flatMapCompletable({ token in
                ServerAPI.favorite.addToFavorite(token: token, drugId: id)
            })
    }
    
    func get(count: Int, offset: Int, for userCity: City) -> Single<[Drug]> {
        return user.getToken()
            .flatMap({ token in
                ServerAPI.favorite.getFavorites(token: token, cityId: userCity.id, from: offset, count: count)
            })
    }
    
    func delete(id: Int) -> Completable {
        return user.getToken()
            .flatMapCompletable({ token in
                ServerAPI.favorite.deleteFromFavorite(token: token, drugId: id)
            })
    }
    
    func isExists(userCity: City, id: Int) -> Single<Bool> {
        return user.getToken()
            .flatMap({ token in
                ServerAPI.favorite.getFavorites(token: token, cityId: userCity.id, from: 0, count: nil)
            })
            .map({ $0.contains(where: { $0.id == id }) })
    }
    
}
