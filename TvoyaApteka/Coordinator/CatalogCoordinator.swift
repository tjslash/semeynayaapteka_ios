//
//  CatalogCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 25.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol CatalogCoordinatorDelegate: class {
    
}

class CatalogCoordinator: BaseCoordinator {
    
    public weak var delegate: CatalogCoordinatorDelegate?
    
    override func start() {
        showCatalogPage()
    }
    
    private func showCatalogPage() {
        let viewModel = CatalogViewModel(drugRepository: DrugRepository(),
                                         drugStoreRepository: DrugStoreRepository(),
                                         cartManager: CartManager.shared)
        let viewController = CatalogViewController(viewModel: viewModel)
        viewController.delegate = self
        router.push(viewController, animated: false, completion: nil)
    }
    
    private func showListCategoryPage(title: String, category: [DrugCategory]) {
        let viewController = ListCategoryViewController(category: category)
        viewController.title = title
        viewController.delegate = self
        router.push(viewController, animated: true, completion: nil)
    }
    
    private func showListDrugsPage(title: String, id: Int) {
        let viewModel = ListDrugsViewModel(categoryId: id,
                                           drugRepository: DrugRepository(),
                                           drugStoreRepository: DrugStoreRepository(),
                                           cartManager: CartManager.shared)
        let viewController = ListDrugsViewController(viewModel: viewModel)
        viewController.delegate = self
        viewController.title = title
        router.push(viewController, animated: true, completion: nil)
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

// MARK: CatalogPageDelegate, ListDrugsPageDelegate
extension CatalogCoordinator: CatalogViewControllerDelegate, ListDrugsViewControllerDelegate {
    
    func authorizationRequired() {
        router.visibleViewController?.showAuthorizationAlert(doneAction: { [unowned self] in
            self.startAuthenticationCoordinator()
        })
    }
    
    func selectCategory(_ category: DrugCategory) {
        showListCategoryPage(title: category.title, category: category.subcategories)
    }
    
    func didSelected(drug: Drug) {
        startDrugDetailsCoordinator(drug: drug)
    }
    
    func didSelectFilter() {
        startFilterCoordinator()
    }

}

// MARK: FilterCoordinatorDelegate
extension CatalogCoordinator: FilterCoordinatorDelegate {
    
    func finishFlow(coordinator: FilterCoordinator, filter: DrugFilter?) {
        if let viewController = router.navigationController.visibleViewController as? ListDrugsViewController, let filter = filter {
            viewController.viewModel.apply(filter)
        }
        
        removeChild(coordinator)
    }
    
}

// MARK: AuthenticationCoordinatorDelegate
extension CatalogCoordinator: AuthenticationCoordinatorDelegate {
    
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
extension CatalogCoordinator: DrugDetailsCoordinatorDelegate {
    
    func finishFlow(coordinator: DrugDetailsCoordinator) {
        removeChild(coordinator)
    }
    
}

// MARK: ListCategoryPageDelegate
extension CatalogCoordinator: ListCategoryViewControllerDelegate {
    
    func selectItem(_ category: DrugCategory) {
        if category.subcategories.isEmpty {
            showListDrugsPage(title: category.title, id: category.id)
            return
        }
        
        showListCategoryPage(title: category.title, category: category.subcategories)
    }
    
}
