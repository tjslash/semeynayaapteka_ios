//
//  AppConfiguration.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class AppConfiguration {
    
    // MARK: Static
    static var shared: AppConfiguration = AppConfiguration()
    
    var currentCity: City? {
        get {
            return storage.getCity()
        }
        set(value) {
            storage.save(city: value!)
        }
    }
    
    let favoriteDrugStore: Variable<DrugStore?>

    // MARK: Private
    private let storage: AppConfigurationStorageType = AppConfigurationStorage()
    private let bag = DisposeBag()
    
    private init() {
        self.favoriteDrugStore = Variable<DrugStore?>(nil)
        bindingFavoriteDrugStore()
    }
    
    // MARK: Private metods
    private func bindingFavoriteDrugStore() {
        self.favoriteDrugStore.value = getFavoriteDrugStore()
        
        self.favoriteDrugStore
            .asDriver()
            .drive(onNext: { [weak self] value in
                self?.saveFavoriteDrugStore(value)
            })
            .disposed(by: bag)
    }
    
    private func getFavoriteDrugStore() -> DrugStore? {
        return storage.getDrugStore()
    }
    
    private func saveFavoriteDrugStore(_ drugStore: DrugStore?) {
        storage.save(drugStore: drugStore)
    }
    
}
