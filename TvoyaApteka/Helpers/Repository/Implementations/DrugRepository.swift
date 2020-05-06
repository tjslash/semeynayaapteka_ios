//
//  DrugRepository.swift
//  TvoyaApteka
//
//  Created by BuidMac on 06.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class DrugRepository: DrugRepositoryType {
    
    private static var drugFilter = DrugFilter()
    private var appConfigurator = AppConfiguration.shared
    
    func setDrugFilter(filter: DrugFilter) {
        DrugRepository.drugFilter = filter
    }
    
    func getDrugFilter() -> DrugFilter {
        return DrugRepository.drugFilter
    }
    
    func getSearchSuggestions(query: String) -> Single<String?> {
        return ServerAPI.search.getSearchResults(cityId: appConfigurator.currentCity!.id, query: query)
            .map { $0.suggestions }
    }
    
    func getSearchResults(query: String) -> Single<[Drug]> {
        return ServerAPI.search.getSearchResults(cityId: appConfigurator.currentCity!.id, query: query)
            .map { $0.drugs }
    }
    
    func getListDrugs(category: Int, from: Int, count: Int) -> Single<[Drug]> {
        return ServerAPI.drug.getDrugShortCards(cityId: appConfigurator.currentCity!.id,
                                              inCategory: category,
                                              from: from,
                                              count: count,
                                              filter: DrugRepository.drugFilter)
    }
    
    func getDrug(id: Int) -> Single<Drug?> {
        return ServerAPI.drug.getDrug(cityId: appConfigurator.currentCity!.id, drugId: id)
    }
    
    func getManufacturersAndPrices() -> Single<ManufacturersAndPrice> {
        return ServerAPI.drug.getPricesAndManufacturers(cityId: appConfigurator.currentCity!.id)
    }
    
    func getHits() -> Single<[Drug]> {
        var filter = DrugFilter()
        filter.hit = true
        return ServerAPI.drug.getDrugShortCards(cityId: appConfigurator.currentCity!.id, inCategory: 0, from: 0, count: 1000, filter: filter)
    }
    
    func getSales() -> Single<[Drug]> {
        return getSales(from: 0, count: 1000)
    }
    
    func getSales(from: Int, count: Int) -> Single<[Drug]> {
        var filter = DrugFilter()
        filter.sales = true
        return ServerAPI.drug.getDrugShortCards(cityId: appConfigurator.currentCity!.id, inCategory: 0, from: from, count: count, filter: filter)
    }
    
    func getAnalogs(drugId: Int?) -> Single<[Drug]> {
        return ServerAPI.actual.getActualCards(actualId: 1, cityId: 7, from: 0, count: 30)
    }
    
    func getListTitleActual() -> Single<[ActualCategory]> {
        return ServerAPI.actual.getActualCategories()
    }
    
    func getActuals(titleId: Int, cityId: Int) -> Single<[Drug]> {
        return ServerAPI.actual.getActualCards(actualId: titleId, cityId: cityId, from: 0, count: 30)
    }

}
