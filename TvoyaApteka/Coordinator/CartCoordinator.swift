//
//  CartCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol CartCoordinatorDelegate: class {
    func selectCatalog()
}

class CartCoordinator: BaseCoordinator {
    
    // MARK: Public
    public weak var delegate: CartCoordinatorDelegate?
    
    // MARK: Private
    private let orderRepository: OrderRepositoryType = OrderRepository()
    private let currentUser = AuthManager.shared.currenUser!
    
    override func start() {
        showCartPage()
    }
    
    private func showCartPage() {
        let viewModel = CartViewModel(cartManager: CartManager.shared)
        let page = CartViewController(viewModel: viewModel, drugStoreRepository: DrugStoreRepository())
        page.delegate = self
        router.push(page, animated: false, completion: nil)
    }
    
    private func showOrderSuccessPage(user: AuthUserType, orders: [Order]) {
        let viewModel = OrderSuccessViewModel(user: user, orders: orders, repository: orderRepository)
        let page = OrderSuccessViewController(viewModel: viewModel)
        page.delegate = self
        router.push(page, animated: true, completion: nil)
    }
    
    private func startDrugDetailsCoordinator(drug: Drug) {
        let coordinator = DrugDetailsCoordinator(drugId: drug.id, router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
}

// MARK: CartPageDelegate
extension CartCoordinator: CartViewControllerDelegate {
    
    func successBuy(orders: [Order]) {
        showOrderSuccessPage(user: currentUser, orders: orders)
    }
    
    func selectDrug(_ drug: Drug) {
        startDrugDetailsCoordinator(drug: drug)
    }
    
    func selectCatalog() {
        delegate?.selectCatalog()
    }
    
}

// MARK: OrderSuccessPageDelegate
extension CartCoordinator: OrderSuccessViewControllerDelegate {
    
    func emptyList() {
        router.popModule(animated: true)
    }
    
}

// MARK: DrugDetailsCoordinatorDelegate
extension CartCoordinator: DrugDetailsCoordinatorDelegate {
    
    func finishFlow(coordinator: DrugDetailsCoordinator) {
        removeChild(coordinator)
    }
    
}
