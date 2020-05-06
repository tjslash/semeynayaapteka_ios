//
//  DrugDetailsViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 03.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DrugDetailsViewModel: DrugCellModelDelegate, DrugCellViewModelDelegateHandler {

    // MARK: Input
    var showRecipeAlert: ((@escaping () -> Void) -> Void)?
    var notAuthorization: (() -> Void)?
    var showCount: ((Int, Int, @escaping (Int) -> Void) -> Void)?
    let favoriteBottonDidTap = PublishSubject<Void>()
    let fullDescriptionViewDidTap = PublishSubject<Void>()
    
    // MARK: Output
    let showDescription = PublishSubject<String>()
    let showEmptyAlert = PublishSubject<Void>()
    let favoriteBottonIsEnable: Driver<Bool>
    let favoriteBottonIsSelected = BehaviorSubject<Bool>(value: false)
    let cellModels = PublishSubject<(page: DrugCellModel, analogs: [DrugCellModel], oftenTake: [DrugCellModel])>()
    let isUploading: Driver<Bool>
    let errorMessage = PublishSubject<String>()
    
    // MARK: Private
    private var drug: Drug?
    private var drugId: Int
    private var isFavorite = false
    private let userCity: City
    private let favoriteRepository: FavoriteRepositoryType
    private let drugRepository: DrugRepositoryType
    private let drugStoreRepository: DrugStoreRepositoryType
    private let cartManager: CartManagerType
    private let errorFabric = ErrorMessageFabric()
    private let favoriteBottonIsEnableIndicator = ActivityIndicator()
    private let uploadingIndicator = ActivityIndicator()
    private let authManager = AuthManager.shared
    private let bag = DisposeBag()
    
    // swiftlint:disable line_length
    init(id drugId: Int, userCity: City, drugRepository: DrugRepositoryType, favoriteRepository: FavoriteRepositoryType, cartManager: CartManagerType, drugStoreRepository: DrugStoreRepositoryType) {
        // swiftlint:enable line_length
        self.drugRepository = drugRepository
        self.drugId = drugId
        self.userCity = userCity
        self.cartManager = cartManager
        self.favoriteRepository = favoriteRepository
        self.drugStoreRepository = drugStoreRepository
        
        self.isUploading = uploadingIndicator
            .asDriver()
        
        self.favoriteBottonIsEnable = favoriteBottonIsEnableIndicator
            .asDriver()
            .map({ !$0 })
        
        self.favoriteBottonDidTap
            .bind(onNext: { [unowned self] in
                self.favoriteButtonDidTapHandler()
            })
            .disposed(by: bag)
        
        self.fullDescriptionViewDidTap
            .bind(onNext: { [unowned self] in
                self.showDrugDescriptionPage()
            })
            .disposed(by: bag)
    }
    
    func uploadPageData() {
        uploadDrug()
        uploadIsFavorite()
    }
    
    private func uploadDrug() {
        drugRepository.getDrug(id: drugId)
            .trackActivity(uploadingIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] drug in
                guard let drug = drug, let strongSelf = self else { return }
                strongSelf.drug = drug
                let pageModel = strongSelf.makeCellModel(from: drug)
                let analogsModels = drug.analogs.map({ strongSelf.makeCellModel(from: $0) })
                let oftenTakeModels = drug.tooBuy.map({ strongSelf.makeCellModel(from: $0) })
                strongSelf.cellModels.onNext((page: pageModel, analogs: analogsModels, oftenTake: oftenTakeModels))
            }).disposed(by: bag)
    }
    
    private func uploadIsFavorite() {
        favoriteRepository.isExists(userCity: userCity, id: drugId)
            .trackActivity(favoriteBottonIsEnableIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] isExists in
                self?.favoriteBottonIsSelected.onNext(isExists)
            }, onError: { [weak self] error in
                self?.showErrorMessage(error)
            }).disposed(by: bag)
    }
    
    private func showDrugDescriptionPage() {
        guard let drug = drug else { return }

        if let html = drug.rlcDescription {
            showDescription.onNext(html)
        } else {
            showEmptyAlert.onNext(())
        }
    }
    
    private func favoriteButtonDidTapHandler() {
        if isFavorite {
            self.removeFromFavorite()
        } else {
            self.addToFavorite()
        }
        
        isFavorite = !isFavorite
    }
    
    private func addToFavorite() {
        guard let drug = drug else { return }
        
        favoriteRepository.add(id: drug.id)
            .trackActivity(favoriteBottonIsEnableIndicator)
            .asCompletable()
            .subscribe(onCompleted: { [weak self] in
                self?.favoriteBottonIsSelected.onNext(true)
            },
            onError: { [weak self] error in
                self?.showErrorMessage(error)
            }).disposed(by: bag)
    }
    
    private func removeFromFavorite() {
        guard let drug = drug else { return }
        
        favoriteRepository.delete(id: drug.id)
            .trackActivity(favoriteBottonIsEnableIndicator)
            .asCompletable()
            .subscribe(onCompleted: { [weak self] in
                self?.favoriteBottonIsSelected.onNext(false)
            },
            onError: { [weak self] error in
                self?.showErrorMessage(error)
            }).disposed(by: bag)
    }
    
    func makeCellModel(from drug: Drug) -> DrugCellModel {
        let model = DrugCellModel(drug: drug, authManager: authManager,
                                  cartManager: cartManager, drugStoreRepository: drugStoreRepository)
        
        model.delegate = self
        return model
    }
    
    func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
}
