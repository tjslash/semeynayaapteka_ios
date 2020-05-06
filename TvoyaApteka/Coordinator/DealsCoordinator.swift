//
//  DealsCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol DealsCoordinatorDelegate: class {
    func finishFlow(coordinator: DealsCoordinator)
}

class DealsCoordinator: BaseCoordinator {
    
    public weak var delegate: DealsCoordinatorDelegate?
    
    // MARK: Private
    private let appConfiguration = AppConfiguration.shared
    private let drugStoreRepository: DrugStoreRepositoryType = DrugStoreRepository()
    private let promoRepository: PromoRepositoryType = PromoRepository()
    private let cartManager = CartManager.shared
    
    override func start() {
        showListDealsPage()
    }
    
    override func start(with option: DeepLinkOption?) {
        guard let option = option else {
            delegate?.finishFlow(coordinator: self)
            return
        }
        
        switch option {
        case .deals:
            showListDealsPage()
        default:
            delegate?.finishFlow(coordinator: self)
        }
    }
    
    private func showListDealsPage() {
        let viewModel = ListDealsViewModel(repository: promoRepository)
        let viewController = ListDealsViewController(viewModel: viewModel)
        viewController.delegate = self
        router.push(viewController, animated: true, completion: { [unowned self] in self.delegate?.finishFlow(coordinator: self) })
    }
    
    private func showDealDetailsPage(id: Int, completion:(() -> Void)? = nil) {
        let viewModel = DealDetailsViewModel(id: id,
                         userCity: appConfiguration.currentCity!,
                         drugStoreRepository: drugStoreRepository,
                         promoRepository: promoRepository,
                         cartManager: cartManager)
        
        let viewController = DealDetailsViewController(viewModel: viewModel)
        viewController.delegate = self
        router.push(viewController, animated: true, completion: completion)
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

// MARK: ListDealsPageDelegate
extension DealsCoordinator: ListDealsViewControllerDelegate {
    
    func selectDeal(id: Int) {
        showDealDetailsPage(id: id)
    }
    
}

// MARK: DealDetailsPageDelegate
extension DealsCoordinator: DealDetailsViewControllerDelegate {
    
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
extension DealsCoordinator: AuthenticationCoordinatorDelegate {
    
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
extension DealsCoordinator: DrugDetailsCoordinatorDelegate {
    
    func finishFlow(coordinator: DrugDetailsCoordinator) {
        removeChild(coordinator)
    }
    
}
