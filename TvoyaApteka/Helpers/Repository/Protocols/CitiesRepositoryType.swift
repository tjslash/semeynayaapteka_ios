//
//  CitiesRepositoryType.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

protocol CitiesRepositoryType {
    func getAllRegionsAndCities() -> Single<[Region]>
}
