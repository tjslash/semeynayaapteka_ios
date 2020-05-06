//
//  SearchService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 02.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift

class SearchAPI: SearchAPIProtocol {
    
    private let adapter = NetworkAdapter<DrugRequest>()
    
    func getSearchResults(cityId: Int, query: String) -> Single<SearchResults> {
        let request = DrugRequest.search(query: query, inCity: cityId, from: 0, count: 100)
        return adapter.send(request: request)
            .mapObject(to: SearchResults.self, keyPath: "data")
    }
    
}
