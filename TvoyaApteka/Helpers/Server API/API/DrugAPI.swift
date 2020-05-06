//
//  TradesService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 23.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift

class DrugAPI: DrugAPIProtocol {

    private let adapter = NetworkAdapter<DrugRequest>()
    
    func getDrug(cityId: Int, drugId: Int) -> Single<Drug?> {
        return adapter.send(request: .getDrug(inCity: cityId, drugId: drugId))
            .mapOptionalObject(to: Drug.self, keyPath: "data")
    }
    
    func getDrugShortCards(cityId: Int, inCategory: Int, from: Int, count: Int, filter: DrugFilter?) -> Single<[Drug]> {
        guard from >= 0, count >= 0 else { return Single.just([]) }
        
        return adapter.send(request: .getDrugShortCards(inCategory: inCategory, inCity: cityId, from: from, count: count, filter: filter))
            .mapArray(to: Drug.self, keyPath: "data")
    }
    
    func getPricesAndManufacturers(cityId: Int) -> Single<ManufacturersAndPrice> {
        return adapter.send(request: .getManufacturers(inCity: cityId))
            .mapObject(to: ManufacturersAndPrice.self, keyPath: "data")
    }
    
}
