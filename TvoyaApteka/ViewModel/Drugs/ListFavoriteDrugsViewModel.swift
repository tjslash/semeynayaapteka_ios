//
//  ListFavoriteDrugsViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 03.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ListFavoriteDrugsViewModel: DrugCellModelDelegate, DrugCellViewModelDelegateHandler {
    
    // MARK: Input
    var showRecipeAlert: ((@escaping () -> Void) -> Void)?
    var notAuthorization: (() -> Void)?
    var showCount: ((Int, Int, @escaping (Int) -> Void) -> Void)?
    var showDeleteAlert: ((@escaping () -> Void) -> Void)?
    
    // MARK: Output
    let cellModels = Variable<[DrugCellModel]>([])
    let isUploading: Driver<Bool>
    let isLoadingMore: Driver<Bool>
    let isRefreshing: Driver<Bool>
    let errorMessage = PublishSubject<String>()
    
    // MARK: Private
    private let loadAtOnce = 20
    private var loadMoreStatus = false
    private var allCardsLoaded = false
    private let favoriteRepository: FavoriteRepositoryType
    private let drugStoreRepository: DrugStoreRepositoryType
    private let errorFabric = ErrorMessageFabric()
    private let uploadActivityIndicator = ActivityIndicator()
    private let loadMoreActivityIndicator = ActivityIndicator()
    private let refreshingActivityIndicator = ActivityIndicator()
    private let appConfigurator = AppConfiguration.shared
    private let authManager = AuthManager.shared
    private let bag = DisposeBag()
    
    init(favoriteRepository: FavoriteRepositoryType, drugStoreRepository: DrugStoreRepositoryType) {
        self.favoriteRepository = favoriteRepository
        self.drugStoreRepository = drugStoreRepository
        
        self.isUploading = uploadActivityIndicator.asDriver()
        self.isLoadingMore = loadMoreActivityIndicator.asDriver()
        self.isRefreshing = refreshingActivityIndicator.asDriver()
    }
    
    func uploadFavorite() {
        favoriteRepository.get(count: loadAtOnce, offset: 0, for: appConfigurator.currentCity!)
            .trackActivity(uploadActivityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [unowned self] drugs in
                self.allCardsLoaded = drugs.count < self.loadAtOnce
                let models = drugs.map({ [unowned self] in self.makeCellModel(from: $0) })
                self.cellModels.value = models
            }, onError: { [weak self] error in
                    self?.showErrorMessage(error)
            }).disposed(by: bag)
    }
    
    func refreshFavorite() {
        favoriteRepository.get(count: loadAtOnce, offset: 0, for: appConfigurator.currentCity!)
            .trackActivity(refreshingActivityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [unowned self] drugs in
                self.allCardsLoaded = drugs.count < self.loadAtOnce
                let models = drugs.map({ [unowned self] in self.makeCellModel(from: $0) })
                self.cellModels.value = models
            }, onError: { [weak self] error in
                    self?.showErrorMessage(error)
            }).disposed(by: bag)
    }
    
    func loadMore() {
        if loadMoreStatus == false && allCardsLoaded == false {
            self.loadMoreStatus = true
            
            favoriteRepository.get(count: loadAtOnce, offset: cellModels.value.count, for: appConfigurator.currentCity!)
                .trackActivity(loadMoreActivityIndicator)
                .asSingle()
                .subscribe(onSuccess: { [unowned self] drugs in
                    self.allCardsLoaded = drugs.count < self.loadAtOnce
                    let models = drugs.map({ [unowned self] in self.makeCellModel(from: $0) })
                    self.cellModels.value.append(contentsOf: models)
                    self.loadMoreStatus = false
                }, onError: { [weak self] error in
                    self?.loadMoreStatus = false
                    self?.showErrorMessage(error)
                }).disposed(by: bag)
        }
    }
    
    func deleteFavorite(by id: Int) {
        favoriteRepository.delete(id: id)
            .trackActivity(uploadActivityIndicator)
            .asCompletable()
            .subscribe(onCompleted: { [unowned self] in
                for index in 0..<self.cellModels.value.count where self.cellModels.value[index].drug.id == id {
                    self.cellModels.value.remove(at: index)
                    break
                }
            }, onError: { [weak self] error in
                self?.showErrorMessage(error)
            }).disposed(by: bag)
    }
    
    private func makeCellModel(from drug: Drug) -> DrugCellModel {
        let model = DrugCellModel(drug: drug, authManager: authManager,
                                  cartManager: CartManager.shared, drugStoreRepository: drugStoreRepository)
        
        model.delegate = self
        return model
    }
    
    internal func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
}
