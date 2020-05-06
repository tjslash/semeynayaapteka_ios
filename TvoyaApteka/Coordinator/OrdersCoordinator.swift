//
//  OrdersCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol OrdersCoordinatorDelegate: class {
    func finishFlow(coordinator: OrdersCoordinator)
}

class OrdersCoordinator: BaseCoordinator {
    
    // MARK: Public
    public weak var delegate: OrdersCoordinatorDelegate?
    
    // MARK: Private
    private let orderRepository: OrderRepositoryType = OrderRepository()
    private let authManager: AuthManagerType = AuthManager.shared
    
    override func start() {
        guard let user = authManager.currenUser else {
            router.visibleViewController?.showAuthorizationAlert(cancelAction: { [unowned self] in
                self.delegate?.finishFlow(coordinator: self)
                }, doneAction: { [unowned self] in
                    self.startAuthenticationCoordinator()
            })
            return
        }
        
        showListOrders(user: user)
    }
    
    override func start(with option: DeepLinkOption?) {
        guard let option = option else {
            delegate?.finishFlow(coordinator: self)
            return
        }
        
        switch option {
        case .order(let id):
            guard let user = authManager.currenUser else { return }

            showOrderDetails(user: user, id: id) { [unowned self] in
                self.delegate?.finishFlow(coordinator: self)
            }
        default:
            delegate?.finishFlow(coordinator: self)
        }
    }
    
    private func startAuthenticationCoordinator() {
        let coordinator = AuthenticationCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func showListOrders(user: AuthUserType) {
        let viewModel = ListOrdersViewModel(user: user, repository: orderRepository)
        let viewController = ListOrdersViewController(viewModel: viewModel)
        viewController.delegate = self
        router.push(viewController, animated: true, completion: { [unowned self] in self.delegate?.finishFlow(coordinator: self) })
    }
    
    private func showOrderDetails(user: AuthUserType, id: Int, completion: (() -> Void)? = nil) {
        let viewModel = OrderDetailsViewModel(user: user, orderId: id, repository: orderRepository)
        let viewController = OrderDetailsViewController(viewModel: viewModel)
        viewController.delegate = self
        router.push(viewController, animated: true, completion: completion)
    }
    
    private func startDrugDetailsCoordinator(drug: Drug) {
        let coordinator = DrugDetailsCoordinator(drugId: drug.id, router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
}

extension OrdersCoordinator: AuthenticationCoordinatorDelegate {
    
    func successLogin(user: AuthUserType, coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
        showListOrders(user: user)
    }
    
    func cancelLogint(coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
    }
    
}

// MARK: ListOrdersPageDelegate
extension OrdersCoordinator: ListOrdersViewControllerDelegate {
    
    func selectOrder(id: Int) {
        showOrderDetails(user: authManager.currenUser!, id: id)
    }
    
}

// MARK: ListOrdersPageBackDelegate
extension OrdersCoordinator: ListOrdersViewControllerBackDelegate {
    
    func didSelect(item: Drug) {
        startDrugDetailsCoordinator(drug: item)
    }
    
    func deleted(order: Order) {
        router.popModule(animated: true)
    }
    
}

// MARK: DrugDetailsCoordinatorDelegate
extension OrdersCoordinator: DrugDetailsCoordinatorDelegate {
    
    func finishFlow(coordinator: DrugDetailsCoordinator) {
        removeChild(coordinator)
    }
    
}
