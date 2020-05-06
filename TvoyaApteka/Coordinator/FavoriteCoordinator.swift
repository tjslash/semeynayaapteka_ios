//
//  FavoriteCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol FavoriteCoordinatorDelegate: class {
    func finishFlow(coordinator: FavoriteCoordinator)
}

class FavoriteCoordinator: BaseCoordinator {
    
    public weak var delegate: FavoriteCoordinatorDelegate?
    
    override func start() {
        showFavoritePage()
    }
    
    private func showFavoritePage() {
        let page = getFavoritePage()
        page.delegate = self
        router.push(page, animated: true, completion: { [unowned self] in self.delegate?.finishFlow(coordinator: self) })
    }
    
    private func getFavoritePage() -> ListFavoriteDrugsViewController {
        let localStorage = UserDefaultsFavoriteStorage(storeKey: Const.localFavoriteStorageKey)
        let favoriteRepository = FavoriteRepository(localStorage: localStorage, authManager: AuthManager.shared)
        let viewModel = ListFavoriteDrugsViewModel(favoriteRepository: favoriteRepository,
                                                   drugStoreRepository: DrugStoreRepository())
        return ListFavoriteDrugsViewController(viewModel: viewModel)
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

// MARK: FavoriteDrugsPageDelegate
extension FavoriteCoordinator: ListFavoriteDrugsViewControllerDelegate {
    
    func authorizationRequired() {
        router.visibleViewController?.showAuthorizationAlert(doneAction: { [unowned self] in
            self.startAuthenticationCoordinator()
        })
    }
    
    func didSelected(drug: Drug) {
        startDrugDetailsCoordinator(drug: drug)
    }
    
}

// MARK: AuthenticationCoordinatorDelegate
extension FavoriteCoordinator: AuthenticationCoordinatorDelegate {
    
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
extension FavoriteCoordinator: DrugDetailsCoordinatorDelegate {
    
    func finishFlow(coordinator: DrugDetailsCoordinator) {
        removeChild(coordinator)
    }
    
}
