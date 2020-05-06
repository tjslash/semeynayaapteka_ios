//
//  EListDrugsViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 08.02.2019.
//  Copyright © 2019 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EListDrugsViewModel: DrugCellModelDelegate, DrugCellViewModelDelegateHandler {
    
    // MARK: Input
    var showRecipeAlert: ((@escaping () -> Void) -> Void)?
    var notAuthorization: (() -> Void)?
    var showCount: ((Int, Int, @escaping (Int) -> Void) -> Void)?
    var refreshData = PublishSubject<Void>()
    
    // MARK: Output
    let cellModels = Variable<[DrugCellModel]>([])
    let isUploading: Driver<Bool>
    let isLoadingMore: Driver<Bool>
    let isRefreshing: Driver<Bool>
    let errorMessage = PublishSubject<String>()
    
    // MARK: Private
    private let drugRepository: DrugRepositoryType
    private let drugStoreRepository: DrugStoreRepositoryType
    private let cartManager: CartManagerType
    private let loadAtOnce = 20
    private var loadMoreStatus = false
    private var allCardsLoaded = false
    private let errorFabric = ErrorMessageFabric()
    private let loadMoreActivityIndicator = ActivityIndicator()
    private let refreshingActivityIndicator = ActivityIndicator()
    private let activityIndicator = ActivityIndicator()
    private let authManager = AuthManager.shared
    private let bag = DisposeBag()
    
    init(drugRepository: DrugRepositoryType, drugStoreRepository: DrugStoreRepositoryType, cartManager: CartManagerType) {
        self.drugRepository = drugRepository
        self.drugStoreRepository = drugStoreRepository
        self.cartManager = cartManager
        
        self.isUploading = activityIndicator.asDriver()
        self.isLoadingMore = loadMoreActivityIndicator.asDriver()
        self.isRefreshing = refreshingActivityIndicator.asDriver()
        
        refreshData
            .bind(onNext: {
                self.refreshDrugList()
            })
            .disposed(by: bag)
    }
    
    func firstUploadDrugs() {
        drugRepository.getSales(from: 0, count: loadAtOnce)
            .trackActivity(activityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [unowned self] drugs in
                self.allCardsLoaded = drugs.count < self.loadAtOnce
                let models = drugs.map({ [unowned self] in self.makeCellModel(from: $0) })
                self.cellModels.value = models
                }, onError: { [weak self] error in
                    self?.showErrorMessage(error)
                })
            .disposed(by: bag)
    }
    
    func loadMore() {
        if loadMoreStatus == false && allCardsLoaded == false {
            self.loadMoreStatus = true
            
            drugRepository.getSales(from: cellModels.value.count, count: loadAtOnce)
                .trackActivity(loadMoreActivityIndicator)
                .asSingle()
                .subscribe(onSuccess: { [weak self] drugs in
                    guard let strongSelf = self else { return }
                    strongSelf.allCardsLoaded = drugs.count < strongSelf.loadAtOnce
                    let models = drugs.map({ strongSelf.makeCellModel(from: $0) })
                    strongSelf.cellModels.value.append(contentsOf: models)
                    self?.loadMoreStatus = false
                    }, onError: { [weak self] error in
                        self?.loadMoreStatus = false
                        self?.showErrorMessage(error)
                })
                .disposed(by: bag)
        }
    }
    
    private func refreshDrugList() {
        drugRepository.getSales(from: 0, count: loadAtOnce)
            .trackActivity(refreshingActivityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [unowned self] drugs in
                let models = drugs.map({ [unowned self] in self.makeCellModel(from: $0) })
                self.cellModels.value = models
                }, onError: { [weak self] error in
                    self?.showErrorMessage(error)
            })
            .disposed(by: bag)
    }
    
    func apply(_ filter: DrugFilter) {
        drugRepository.setDrugFilter(filter: filter)
        firstUploadDrugs()
    }
    
    private func makeCellModel(from drug: Drug) -> DrugCellModel {
        let cellModel = DrugCellModel(drug: drug, authManager: authManager,
                                      cartManager: cartManager,
                                      drugStoreRepository: drugStoreRepository)
        cellModel.delegate = self
        return cellModel
    }
    
    internal func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
}
