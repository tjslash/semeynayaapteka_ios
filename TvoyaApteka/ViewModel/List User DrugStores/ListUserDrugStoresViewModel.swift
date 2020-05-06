//
//  ListUserDrugStoresViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 02.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ListUserDrugStoresViewModelDelegate: class {
    func userSelect(store: DrugStore)
}

class ListUserDrugStoresViewModel {
    
    // MARK: Output
    let cellModels = PublishSubject<[DrugStoreCellModel]>()
    
    // MARK: Public
    weak var delegate: ListUserDrugStoresViewModelDelegate?
    
    // MARK: Private
    private let drugStoreRepository: DrugStoreRepositoryType
    private let bag = DisposeBag()
    
    init(drugStoreRepository: DrugStoreRepositoryType) {
        self.drugStoreRepository = drugStoreRepository
    }
    
    func didSelect(store: DrugStore) {
        delegate?.userSelect(store: store)
    }
    
    func uploadListStores() {
        let drugStores = drugStoreRepository.getAllDrugStores()
        let models = drugStores.map({ DrugStoreCellModel(drugStore: $0) })
        self.cellModels.onNext(models)
    }
    
}
