//
//  UserDefaultsFavoriteStorage.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 16.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

class UserDefaultsFavoriteStorage: FavoriteStorageProtocol {
    
    private let storeKey: String
    private let userDefaults = UserDefaults.standard
    
    init(storeKey: String) {
        self.storeKey = storeKey
    }
    
    func getAll() -> [Int] {
        let setDrurs = loadFromLocalCache()
        return Array(setDrurs)
    }
    
    func add(drugId: [Int]) {
        saveInLocalCache(drugIds: drugId)
    }
    
    func add(drugId: Int) {
        var local = loadFromLocalCache()
        local.insert(drugId)
        saveInLocalCache(drugIds: Array(local))
    }
    
    func delete(drugId: Int) {
        var local = loadFromLocalCache()
        local.remove(drugId)
        saveInLocalCache(drugIds: Array(local))
    }
    
    func isExists(drugId: Int) -> Bool {
        return loadFromLocalCache().contains(drugId)
    }
    
    func deleteAll() {
        clearLocalCache()
    }
    
    private func loadFromLocalCache() -> Set<Int> {
        let cacheString = userDefaults.string(forKey: storeKey)
        let drugsIds = cacheString?.components(separatedBy: ",").compactMap { Int($0) } ?? []
        return Set(drugsIds)
    }
    
    private func saveInLocalCache(drugIds: [Int]) {
        let uniqueIds = Set(drugIds)
        let saveString = uniqueIds.map {"\($0)"}.joined(separator: ",")
        userDefaults.setValue(saveString, forKey: storeKey)
    }
    
    private func clearLocalCache() {
        userDefaults.removeObject(forKey: storeKey)
    }
    
}
