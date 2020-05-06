//
//  FavoriteStorageProtocol.swift
//  TvoyaApteka
//
//  Created by BuidMac on 31.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol FavoriteStorageProtocol {
    func getAll() -> [Int]
    func add(drugId: [Int])
    func add(drugId: Int)
    func delete(drugId: Int)
    func isExists(drugId: Int) -> Bool
    func isEmpty() -> Bool
    func deleteAll()
}

extension FavoriteStorageProtocol {
    
    func isEmpty() -> Bool {
        return getAll().isEmpty
    }
    
}
