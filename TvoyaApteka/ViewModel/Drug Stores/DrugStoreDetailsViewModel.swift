//
//  DrugStoreDetailsViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 03.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DrugStoreDetailsViewModel {
    
    // MARK: Output
    let store = PublishSubject<DrugStore>()
    let isUploading: Driver<Bool>
    let errorMessage = PublishSubject<String>()
    
    // MARK: Private
    private let storeId: Int
    private let drugStoreRepository: DrugStoreRepositoryType
    private let activityIndacator = ActivityIndicator()
    private let errorFabric = ErrorMessageFabric()
    private let bag = DisposeBag()
    
    init(storeId: Int, drugStoreRepository: DrugStoreRepositoryType) {
        self.storeId = storeId
        self.drugStoreRepository = drugStoreRepository
        self.isUploading = activityIndacator.asDriver()
    }
    
    func uploadStore() {
        drugStoreRepository.getDrugStore(storeId: storeId)
            .trackActivity(activityIndacator)
            .asSingle()
            .subscribe(
                onSuccess: { [weak self] store in
                    self?.store.onNext(store)
                },
                onError: { [weak self] error in
                    self?.showErrorMessage(error)
            }).disposed(by: bag)
    }
    
    private func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
}
