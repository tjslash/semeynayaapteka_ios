//
//  CitiesService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 02.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift

class CitiesAPI: CitiesAPIProtocol {
    
    private let adapter = NetworkAdapter<CitiesRequest>()
    
    func getAllRegionsAndCities() -> Single<[Region]> {
        return adapter.send(request: .getAllRegionsAndCities)
            .mapArray(to: Region.self, keyPath: "data")
    }
    
}
