//
//  DrugStoreService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 02.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift

class DrugStoreAPI: DrugStoresAPIProtocol {
    
    private let adapter = NetworkAdapter<DrugStoreRequest>()
    
    func getAllDrugStores(cityId: Int) -> Single<[DrugStore]> {
        return adapter.send(request: .getAllDrugStores(inCity: cityId))
            .mapArray(to: DrugStore.self, keyPath: "data")
    }
    
    func getDrugStore(storeId: Int) -> Single<DrugStore> {
        return adapter.send(request: .getDrugStore(storeId: storeId))
            .mapObject(to: DrugStore.self, keyPath: "data")
    }

}
