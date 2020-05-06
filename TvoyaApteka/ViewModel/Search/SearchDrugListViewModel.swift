//
//  SearchResultsViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 02.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchDrugListViewModelDelegate: class {
    func authorizationRequired()
    func didSelected(drug: Drug)
}

class SearchDrugListViewModel: DrugCellModelDelegate, DrugCellViewModelDelegateHandler {
    
    // MARK: Input
    var showCount: ((Int, Int, @escaping (Int) -> Void) -> Void)?
    var showRecipeAlert: ((@escaping () -> Void) -> Void)?
    var notAuthorization: (() -> Void)?
    
    // MARK: Output
    let cellModels = BehaviorSubject<[DrugCellModel]>(value: [])
    
    // MARK: Public
    weak var delegate: SearchDrugListViewModelDelegate?
    
    // MARK: Private
    private let authManager = AuthManager.shared
    private let cartManager: CartManagerType
    private let drugStoreRepository: DrugStoreRepositoryType
    
    init(drugs: [Drug], cartManager: CartManagerType, drugStoreRepository: DrugStoreRepositoryType) {
        self.cartManager = cartManager
        self.drugStoreRepository = drugStoreRepository
        initialCellModels(from: drugs)
        
        self.notAuthorization = { [unowned self] in
            self.delegate?.authorizationRequired()
        }
    }
    
    func didSelected(drug: Drug) {
        delegate?.didSelected(drug: drug)
    }
    
    private func initialCellModels(from drugs: [Drug]) {
        let models = drugs.map({ [unowned self] in self.makeCellModel(from: $0) })
        self.cellModels.onNext(models)
    }
    
    private func makeCellModel(from drug: Drug) -> DrugCellModel {
        let model = DrugCellModel(drug: drug, authManager: authManager,
                                  cartManager: cartManager, drugStoreRepository: drugStoreRepository)
        
        model.delegate = self
        return model
    }
    
    func showErrorMessage(_ error: Error) {
        
    }
    
}
