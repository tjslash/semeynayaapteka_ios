//
//  DealDetailsViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 02.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DealDetailsViewModel: DrugCellModelDelegate, DrugCellViewModelDelegateHandler {
    
    // MARK: Input
    var showCount: ((Int, Int, @escaping (Int) -> Void) -> Void)?
    var showRecipeAlert: ((@escaping () -> Void) -> Void)?
    var notAuthorization: (() -> Void)?
    
    // MARK: Output
    let isUploading: Driver<Bool>
    let title = Variable<String>("")
    let errorMessages = PublishSubject<String>()
    let cellModels = PublishSubject<(deal: DealCellModel, drugs: [DrugCellModel])>()
    
    // MARK: Private
    private let promoId: Int
    private let userCity: City
    private let cartManager: CartManagerType
    private let drugStoreRepository: DrugStoreRepositoryType
    private let promoRepository: PromoRepositoryType
    private let errorFabric = ErrorMessageFabric()
    private let activityIndicator = ActivityIndicator()
    private let authManager = AuthManager.shared
    private let bag = DisposeBag()
    
    init(id promoId: Int, userCity: City, drugStoreRepository: DrugStoreRepositoryType, promoRepository: PromoRepositoryType, cartManager: CartManagerType) {
        self.userCity = userCity
        self.promoId = promoId
        self.drugStoreRepository = drugStoreRepository
        self.promoRepository = promoRepository
        self.cartManager = cartManager
        
        self.isUploading = activityIndicator.asDriver()
    }
    
    func uploadPromo() {
        promoRepository.getPromotion(id: promoId, in: userCity)
            .trackActivity(activityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] promotion in
                self?.title.value = "Акции. " + promotion.title
                let dealCellModel = DealCellModel(promotion: promotion)
                let drugsCellModels = promotion.drugs.compactMap({ self?.makeCellModel(from: $0) })
                self?.cellModels.onNext((deal: dealCellModel, drugs: drugsCellModels))
            }, onError: { [weak self] error in
                self?.showErrorMessage(error)
            })
            .disposed(by: bag)
    }
    
    func makeCellModel(from drug: Drug) -> DrugCellModel {
        let model = DrugCellModel(drug: drug, authManager: authManager,
                                  cartManager: cartManager, drugStoreRepository: drugStoreRepository)

        model.delegate = self
        return model
    }
    
    func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessages.onNext(textError)
        }
    }
    
}
