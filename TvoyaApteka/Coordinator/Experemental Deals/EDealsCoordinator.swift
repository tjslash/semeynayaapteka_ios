//
//  EDealsCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 08.02.2019.
//  Copyright © 2019 Tematika. All rights reserved.
//

import Foundation

protocol EDealsCoordinatorDelegate: class {
    func finishFlow(coordinator: EDealsCoordinator)
}

class EDealsCoordinator: BaseCoordinator {
    
    public weak var delegate: EDealsCoordinatorDelegate?
    
    override func start() {
        showListDrugsPage(title: "Акции")
    }
    
    private func showListDrugsPage(title: String) {
        let viewModel = EListDrugsViewModel(drugRepository: DrugRepository(),
                                           drugStoreRepository: DrugStoreRepository(),
                                           cartManager: CartManager.shared)
        let viewController = EListDrugsViewController(viewModel: viewModel)
        viewController.delegate = self
        viewController.title = title
        router.push(viewController, animated: true, completion: { [unowned self] in self.delegate?.finishFlow(coordinator: self) })
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
    
    private func startFilterCoordinator() {
        let coordinator = FilterCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
}

// MARK: ListDrugsPageDelegate
extension EDealsCoordinator: ListDrugsViewControllerDelegate {
    
    func authorizationRequired() {
        router.visibleViewController?.showAuthorizationAlert(doneAction: { [unowned self] in
            self.startAuthenticationCoordinator()
        })
    }
    
    func didSelected(drug: Drug) {
        startDrugDetailsCoordinator(drug: drug)
    }
    
    func didSelectFilter() {
        startFilterCoordinator()
    }
    
}

// MARK: FilterCoordinatorDelegate
extension EDealsCoordinator: FilterCoordinatorDelegate {
    
    func finishFlow(coordinator: FilterCoordinator, filter: DrugFilter?) {
        if let viewController = router.navigationController.visibleViewController as? ListDrugsViewController, let filter = filter {
            viewController.viewModel.apply(filter)
        }
        
        removeChild(coordinator)
    }
    
}

// MARK: AuthenticationCoordinatorDelegate
extension EDealsCoordinator: AuthenticationCoordinatorDelegate {
    
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
extension EDealsCoordinator: DrugDetailsCoordinatorDelegate {
    
    func finishFlow(coordinator: DrugDetailsCoordinator) {
        removeChild(coordinator)
    }
    
}
