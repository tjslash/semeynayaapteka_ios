//
//  DrugStoreRepository.swift
//  TvoyaApteka
//
//  Created by BuidMac on 24.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class DrugStoreRepository: DrugStoreRepositoryType {
    
    static private var cache: [Int: DrugStore] = [:]
    
    private let remoteServer = ServerAPI.drugStore
    
    func getAllDrugStores() -> [DrugStore] {
        return Array(DrugStoreRepository.cache.values)
    }
    
    func getDrugStore(storeId: Int) -> Single<DrugStore> {
        if let drugStore = DrugStoreRepository.cache[storeId] {
            return Single.just(drugStore)
        }
        
        return remoteServer.getDrugStore(storeId: storeId)
    }
    
    func cached(for city: City) -> Completable {
        return remoteServer.getAllDrugStores(cityId: city.id)
            .do(onSuccess: { drugStores in
                drugStores.forEach({ store in
                    DrugStoreRepository.cache[store.id] = store
                })
            })
            .asCompletable()
    }
    
    static func clearCache() {
        cache.removeAll()
    }
    
}
