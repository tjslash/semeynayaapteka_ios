//
//  CatalogViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 01.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CatalogViewModel: DrugCellModelDelegate, DrugCellViewModelDelegateHandler {
    
    // MARK: Input
    var showRecipeAlert: ((_ handler: @escaping () -> Void) -> Void)?
    var showCount: ((_ min: Int, _ max: Int, _ handler: @escaping (_ selectCount: Int) -> Void) -> Void)?
    var notAuthorization: (() -> Void)?
    
    // MARK: Output
    let isLoading: Driver<Bool>
    let hitIsLoading = ActivityIndicator()
    let saleIsLoading = ActivityIndicator()
    let actualIsLoading = ActivityIndicator()
    let listCategories = PublishSubject<[DrugCategory]>()
    let hitCellModels = PublishSubject<[DrugCellModel]>()
    let saleCellModels = PublishSubject<[DrugCellModel]>()
    let actualCellModels = PublishSubject<[DrugCellModel]>()
    let listTitleActual = PublishSubject<[ActualCategory]>()
    let showNotConnectionView = PublishSubject<() -> Void>()
    let errorMessage = PublishSubject<String>()
    
    // MARK: Private
    private let errorFabric = ErrorMessageFabric()
    private let activityIndincator = ActivityIndicator()
    private let drugRepository: DrugRepositoryType
    private let drugStoreRepository: DrugStoreRepositoryType
    private let cartManager: CartManagerType
    private let authManager = AuthManager.shared
    private let bag = DisposeBag()
    
    init(drugRepository: DrugRepositoryType, drugStoreRepository: DrugStoreRepositoryType, cartManager: CartManagerType) {
        self.drugRepository = drugRepository
        self.drugStoreRepository = drugStoreRepository
        self.cartManager = cartManager
        
        isLoading = activityIndincator.asDriver()
    }
    
    // MARK: Public metods
    func uploadActualDrugs(by id: Int) {
        let cityId = AppConfiguration.shared.currentCity?.id ?? 8
        drugRepository.getActuals(titleId: id, cityId: cityId)
            .trackActivity(actualIsLoading)
            .asSingle()
            .subscribe(onSuccess: { [unowned self] drugs in
                let cellModels = drugs.map({ self.makeCellModel(from: $0) })
                self.actualCellModels.onNext(cellModels)
            })
            .disposed(by: bag)
    }
    
    func uploadData() {
        uploadListCategories()
        uploadHitDrugs()
        uploadSaleDrugs()
        uploadListTagsForActualDrugs()
    }
    
    private func uploadListCategories() {
        ServerAPI.drugCategory
            .getAllCategoriesTree()
            .trackActivity(activityIndincator)
            .asSingle()
            .subscribe(onSuccess: { [unowned self] categories in
                self.listCategories.onNext(categories)
            }, onError: { [unowned self] error in
                self.handleError(error)
            }).disposed(by: bag)
    }
    
    private func uploadHitDrugs() {
        drugRepository.getHits()
            .trackActivity(hitIsLoading)
            .asSingle()
            .subscribe(onSuccess: { [unowned self] drugs in
                let cellModels = drugs.map({ self.makeCellModel(from: $0) })
                self.hitCellModels.onNext(cellModels)
            })
            .disposed(by: bag)
    }
    
    private func uploadSaleDrugs() {
        drugRepository.getSales()
            .trackActivity(saleIsLoading)
            .asSingle()
            .subscribe(onSuccess: { [unowned self] drugs in
                let cellModels = drugs.map({ self.makeCellModel(from: $0) })
                self.saleCellModels.onNext(cellModels)
            })
            .disposed(by: bag)
    }
    
    private func uploadListTagsForActualDrugs() {
        drugRepository.getListTitleActual()
            .subscribe(onSuccess: { [unowned self] tags in
                self.listTitleActual.onNext(tags)
            })
            .disposed(by: bag)
    }
    
    private func makeCellModel(from drug: Drug) -> DrugCellModel {
        let model = DrugCellModel(drug: drug, authManager: authManager,
                                  cartManager: cartManager, drugStoreRepository: drugStoreRepository)
        
        model.delegate = self
        return model
    }
    
    private func handleError(_ error: Error) {
        guard let serviceError = error as? ServiceError else {
            showErrorMessage(error)
            return
        }
        
        switch serviceError {
        case .noConnectionToServer:
            self.showNotConnectionView.onNext({ [weak self] in self?.uploadData() })
        default:
            showErrorMessage(error)
        }
    }
    
    internal func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
}
