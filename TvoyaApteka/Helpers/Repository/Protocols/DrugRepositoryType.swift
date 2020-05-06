//
//  DrugRepositoryType.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

protocol DrugRepositoryType {
    func setDrugFilter(filter: DrugFilter)
    func getDrugFilter() -> DrugFilter
    
    func getSearchSuggestions(query: String) -> Single<String?>
    func getSearchResults(query: String) -> Single<[Drug]>
    
    func getManufacturersAndPrices() -> Single<ManufacturersAndPrice>
    func getListDrugs(category: Int, from: Int, count: Int) -> Single<[Drug]>
    func getDrug(id: Int) -> Single<Drug?>
    func getHits() -> Single<[Drug]>
    func getSales() -> Single<[Drug]>
    func getSales(from: Int, count: Int) -> Single<[Drug]>
    func getAnalogs(drugId: Int?) -> Single<[Drug]>
    
    func getListTitleActual() -> Single<[ActualCategory]>
    func getActuals(titleId: Int, cityId: Int) -> Single<[Drug]>
}
