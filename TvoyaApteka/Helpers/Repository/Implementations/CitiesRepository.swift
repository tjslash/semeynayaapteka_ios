//
//  CitiesRepository.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class CitiesRepository: CitiesRepositoryType {
    
    // MARK: Private
    static private var cachedRegions: [Region]?
    
    func getAllRegionsAndCities() -> Single<[Region]> {
        if let cache = CitiesRepository.cachedRegions {
            return Single.just(cache)
        } else {
            return ServerAPI.cities.getAllRegionsAndCities()
                .do(onSuccess: { regions in
                    CitiesRepository.cachedRegions = regions
                })
        }
    }
    
}
