//
//  DrugStoresViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 03.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DrugStoresViewModel {
    
    // MARK: Output
    let stores = PublishSubject<[DrugStore]>()
    let isUploading: Driver<Bool>
    let errorMessage = PublishSubject<String>()
    
    // MARK: Private
    private let locationManager: LocationManager
    private let drugStoreRepository: DrugStoreRepositoryType
    private let activityIndicator = ActivityIndicator()
    private let errorFabric = ErrorMessageFabric()
    private let bag = DisposeBag()
    
    init(locationManager: LocationManager, drugStoreRepository: DrugStoreRepositoryType) {
        self.locationManager = locationManager
        self.drugStoreRepository = drugStoreRepository
        
        self.isUploading = activityIndicator.asDriver()
    }
    
    func startUpdatingLocation() {
        locationManager.tryToStartGpsService()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopGpsService()
    }
    
    func uploadStores() {
        let drugStores = drugStoreRepository.getAllDrugStores()
        let sortedDrugStores = sortNearest(drugStores: drugStores)
        self.stores.onNext(sortedDrugStores)
    }
    
    private func sortNearest(drugStores: [DrugStore]) -> [DrugStore] {
        guard let userPos = locationManager.getLastLocation() else { return drugStores }
        let noDistanceStores = drugStores.filter { $0.distanceTo(userPosition: userPos) == nil }
        let normalStores = drugStores.filter { $0.distanceTo(userPosition: userPos) != nil }
        var stores = normalStores.sorted { store1, store2 in
            let distance1 = store1.distanceTo(userPosition: userPos) ?? 1000000
            let distance2 = store2.distanceTo(userPosition: userPos) ?? 1000000
            return distance1 > distance2
        }
        stores.append(contentsOf: noDistanceStores)
        return stores
    }
    
    private func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
}
