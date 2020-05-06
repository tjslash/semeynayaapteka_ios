//
//  SearchCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 21.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

protocol SearchCoordinatorDelegate: class {
    func finishFlow(coordinator: SearchCoordinator)
}

class SearchCoordinator: BaseCoordinator {
    
    // MARK: Public
    weak var delegate: SearchCoordinatorDelegate?
    
    // MARK: Private
    private let drugRepository: DrugRepositoryType = DrugRepository()
    private let drugStoreRepository: DrugStoreRepositoryType = DrugStoreRepository()
    private let cartManager: CartManagerType = CartManager.shared
    
    override func start() {
        showSearchPage()
    }
    
    private func showSearchPage() {
        let page = SearchViewController(drugRepository: drugRepository,
                                        drugStoreRepository: drugStoreRepository,
                                        cartManager: cartManager)
        page.delegate = self
        router.push(page, animated: false) { [unowned self] in
            self.delegate?.finishFlow(coordinator: self)
        }
    }
    
    private func startAuthenticationCoordinator() {
        let coordinator = AuthenticationCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startDrugDetailsCoordinator(drug: Drug) {
        let coordinator = DrugDetailsCoordinator(drugId: drug.id, router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
}

// MARK: - SearchAndResultPageDelegate
extension SearchCoordinator: SearchViewControllerDelegate {
    
    func authorizationRequired() {
        startAuthenticationCoordinator()
    }
    
    func didSelected(drug: Drug) {
        startDrugDetailsCoordinator(drug: drug)
    }

}

// MARK: AuthenticationCoordinatorDelegate
extension SearchCoordinator: AuthenticationCoordinatorDelegate {
    
    func successLogin(user: AuthUserType, coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
    }
    
    func cancelLogint(coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
    }
    
}

// MARK: DrugDetailsCoordinatorDelegate
extension SearchCoordinator: DrugDetailsCoordinatorDelegate {
    
    func finishFlow(coordinator: DrugDetailsCoordinator) {
        removeChild(coordinator)
    }
    
}
