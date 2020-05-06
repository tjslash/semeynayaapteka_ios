//
//  NotAuthorizedReceivingStrategy.swift
//  TvoyaApteka
//
//  Created by BuidMac on 20.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class NotAuthorizedReceivingStrategy: FavoriteStrategy {
    
    private let localStorage: FavoriteStorageProtocol
    
    init(localStorage: FavoriteStorageProtocol) {
        self.localStorage = localStorage
    }
    
    func add(id: Int) -> Completable {
        localStorage.add(drugId: id)
        return Completable.empty()
    }
    
    func get(count: Int, offset: Int, for userCity: City) -> Single<[Drug]> {
        let allCachedId = localStorage.getAll()
        
        return Observable.from(allCachedId.slice(count: count, offset: offset))
            .flatMap({ ServerAPI.drug.getDrug(cityId: userCity.id, drugId: $0) })
            .filter({ $0 != nil })
            .map({ $0! })
            .toArray()
            .asSingle()
    }
    
    func delete(id: Int) -> Completable {
        localStorage.delete(drugId: id)
        return Completable.empty()
    }
    
    func isExists(userCity: City, id: Int) -> Single<Bool> {
        return Single.just(localStorage.isExists(drugId: id))
    }
    
}

// MARK: Array
private extension Array where Element == Int {
    
    func slice(count: Int, offset: Int) -> [Element] {
        guard let sliceIndex = getCorrectSliceIndexes(count: count, offset: offset, array: self) else {
            return []
        }
        
        let sliceResult = self[sliceIndex.start...sliceIndex.end]
        return Array(sliceResult)
    }
    
    private func getCorrectSliceIndexes(count: Int, offset: Int, array: [Int]) -> (start: Int, end: Int)? {
        guard offset < array.count else {
            return nil
        }
        
        let startIndex = offset
        var endIndex = offset + count
        
        if endIndex >= array.count {
            endIndex = array.count - 1
        }
        
        return (start: startIndex, end: endIndex)
    }
    
}
