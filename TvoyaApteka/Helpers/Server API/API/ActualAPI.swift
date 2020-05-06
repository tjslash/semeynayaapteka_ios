//
//  ActualService.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 07.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class ActualAPI: ActualsAPIProtocol {
    
    private let adapter = NetworkAdapter<ActualRequest>()
    
    func getActualCategories() -> Single<[ActualCategory]> {
        return adapter.send(request: .actualList)
            .mapArray(to: ActualCategory.self, keyPath: "data")
    }
    
    func getActualCards(actualId: Int, cityId: Int, from: UInt, count: UInt) -> Single<[Drug]> {
        return adapter.send(request: .actual(actualId: actualId, cityId: cityId, from: from, count: count))
            .mapArray(to: Drug.self, keyPath: "data")
    }
    
}
