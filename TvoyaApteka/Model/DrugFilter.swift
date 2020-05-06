//
//  DrugFilter.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

struct DrugFilter {
    var sales: Bool?
    var hit: Bool?
    var manufacturers: [Int] = []
    var priceMin: Double?
    var priceMax: Double?
    var order: OrderType?
    var sort: SortType?
}
