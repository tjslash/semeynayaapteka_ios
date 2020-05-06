//
//  AppConfigurationStorage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 17.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol AppConfigurationStorageType {
    func getCity() -> City?
    func save(city: City?)
    func getDrugStore() -> DrugStore?
    func save(drugStore: DrugStore?)
}

class AppConfigurationStorage: AppConfigurationStorageType {

    // MARK: Private
    private struct Keys {
        static let city = "AppConfiguration_cityKey"
        static let drugStore = "AppConfiguration_drugStore"
    }
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let userDefaults = UserDefaults.standard
    
    func getCity() -> City? {
        return getObject(key: Keys.city)
    }
    
    func save(city: City?) {
        saveObject(city, key: Keys.city)
    }
    
    func getDrugStore() -> DrugStore? {
        return getObject(key: Keys.drugStore)
    }

    func save(drugStore: DrugStore?) {
        saveObject(drugStore, key: Keys.drugStore)
    }
    
    // MARK: Help metods
    
    private func getObject<T: Decodable>(key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        // swiftlint:disable force_try
        return try! decoder.decode(T.self, from: data)
        // swiftlint:enable force_try
    }
    
    private func saveObject<T: Encodable>(_ value: T?, key: String) {
        guard let value = value else {
            userDefaults.set(nil, forKey: key)
            return
        }
        
        // swiftlint:disable force_try
        let data = try! encoder.encode(value)
        // swiftlint:enable force_try
        userDefaults.set(data, forKey: key)
    }
    
}
