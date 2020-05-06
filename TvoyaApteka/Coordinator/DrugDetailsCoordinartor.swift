//
//  DrugDetailsCoordinartor.swift
//  TvoyaApteka
//
//  Created by BuidMac on 21.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol DrugDetailsCoordinatorDelegate: class {
    func finishFlow(coordinator: DrugDetailsCoordinator)
}

class DrugDetailsCoordinator: BaseCoordinator {
    
    public weak var delegate: DrugDetailsCoordinatorDelegate?
    private let drugId: Int
    private let appConfiguration = AppConfiguration.shared
    
    init(drugId: Int, router: RouterType) {
        self.drugId = drugId
        super.init(router: router)
    }
    
    required public init(router: RouterType) {
        fatalError("init(router:) has not been implemented")
    }
    
    override func start() {
        showDrugDetailsPage(id: drugId) { [unowned self] in
            self.delegate?.finishFlow(coordinator: self)
        }
    }
    
    private func showDrugDetailsPage(id: Int, completion: (() -> Void)?) {
        let userCity = appConfiguration.currentCity!
        let drugRepository = DrugRepository()
        let localStore = UserDefaultsFavoriteStorage(storeKey: Const.localFavoriteStorageKey)
        let favoriteRepository = FavoriteRepository(localStorage: localStore, authManager: AuthManager.shared)
       
        let viewModel = DrugDetailsViewModel(id: id,
                                             userCity: userCity,
                                             drugRepository: drugRepository,
                                             favoriteRepository: favoriteRepository,
                                             cartManager: CartManager.shared,
                                             drugStoreRepository: DrugStoreRepository())
        
        let viewController = DrugDetailsViewController(viewModel: viewModel)
        
        viewController.delegate = self
        router.push(viewController, animated: true, completion: completion)
    }
    
    private func showDrugFullDescription(html: String) {
        let page = DrugDescriptionViewController(html: html)
        router.push(page, animated: true, completion: nil)
    }
    
    private func startAuthenticationCoordinator() {
        let coordinator = AuthenticationCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
}

// MARK: - DrugCardPageDelegate
extension DrugDetailsCoordinator: DrugDetailsViewControllerDelegate {
    
    func authorizationRequired() {
        router.visibleViewController?.showAuthorizationAlert(doneAction: { [unowned self] in
            self.startAuthenticationCoordinator()
        })
    }
    
    func didSelectedFullDescription(html: String) {
        showDrugFullDescription(html: html)
    }
    
    func didSelected(drug: Drug) {
        showDrugDetailsPage(id: drug.id, completion: nil)
    }
    
}

// MARK: AuthenticationCoordinatorDelegate
extension DrugDetailsCoordinator: AuthenticationCoordinatorDelegate {
    
    func successLogin(user: AuthUserType, coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
    }
    
    func cancelLogint(coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
    }
    
}
