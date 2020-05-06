//
//  FavoriteService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 29.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class FavoritesAPI: FavoritesAPIProtocol {
    
    private let adapter = NetworkAdapter<FavoriteRequest>()
    private let bag = DisposeBag()
    
    func getFavorites(token: String, cityId: Int, from: Int, count: Int?) -> Single<[Drug]> {
        return serverRequestFavorites(token: token, cityId: cityId, from: from, count: count)
    }
    
    func addToFavorite(token: String, drugId: Int) -> Completable {
        return serverRequestAddFavorite(token: token, drugId: drugId)
    }
    
    func deleteFromFavorite(token: String, drugId: Int) -> Completable {
        return serverRequestDeleteFromFavorite(token: token, drugId: drugId)
    }
    
    private func serverRequestFavorites(token: String, cityId: Int, from: Int, count: Int?) -> Single<[Drug]> {
        guard from >= 0 else { return Single.just([]) }
        
        let request = FavoriteRequest.getFavorite(token: token, userCity: cityId, offset: from, limit: count)
        
        return adapter.send(request: request)
            .mapArray(to: Drug.self, keyPath: "data")
    }
    
    private func serverRequestAddFavorite(token: String, drugId: Int) -> Completable {
        let request = FavoriteRequest.addToFavorite(token: token, drugId: drugId)
        return adapter.send(request: request)
            .asCompletable()
    }
    
    private func serverRequestDeleteFromFavorite(token: String, drugId: Int) -> Completable {        
        let request = FavoriteRequest.deleteFromFavorite(token: token, drugId: drugId)
        return adapter.send(request: request)
            .asCompletable()
    }
    
}
