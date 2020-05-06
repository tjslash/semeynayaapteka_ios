//
//  MainTabbarCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 25.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import Chat

protocol MainTabbarCoordinatorDelegate: class {
    func userSelect(city: City)
    func userSelect(drugStore: DrugStore)
    func userLogout()
}

class MainTabbarCoordinator: BaseCoordinator {
    
    weak var delegate: MainTabbarCoordinatorDelegate?
    
    // MARK: Private
    private let authManager = AuthManager.shared
    
    private lazy var tabController: MainTabBarController = {
        let page = MainTabBarController(cartManager: CartManager.shared)
        page.coordinatorDelegate = self
        return page
    }()
    
    override func start() {
        router.setRootModule(tabController, hideBar: true)
        tabController.showCatalog()
    }
    
    override func start(with option: DeepLinkOption?) {
        guard let option = option else { return }
        
        switch option {
        case .deals:
            if let visibleNavigationController = tabController.visibleViewController as? UINavigationController {
                startDealsCoordinator(navigationController: visibleNavigationController, with: option)
            }
        case .order:
            if let visibleNavigationController = tabController.visibleViewController as? UINavigationController {
                startOrdersCoordinator(navigationController: visibleNavigationController, with: option)
            }
        }
    }
    
    // MARK: Coordinators
    private func startCatalogCoordinator(navigationController: UINavigationController) {
        let router = Router(navigationController: navigationController)
        let coordinator = CatalogCoordinator(router: router)
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startMenuCoordinator(navigationController: UINavigationController) {
        let router = Router(navigationController: navigationController)
        let coordinator = MenuCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startCartCoordinator(navigationController: UINavigationController) {
        let router = Router(navigationController: navigationController)
        let coordinator = CartCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startChatCoordinator(navigationController: UINavigationController) {
        let router = Router(navigationController: navigationController)
        let coordinator = ChatCoordinator(router: router)
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startHotCallCoordinator(navigationController: UINavigationController) {
        let router = Router(navigationController: navigationController)
        let coordinator = HotCallCoordinator(router: router)
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startAuthenticationCoordinator() {
        let coordinator = AuthenticationCoordinator(router: router)
        coordinator.delegate = self
        self.appendChild(coordinator)
        coordinator.start()
    }
    
    private func startOrdersCoordinator(navigationController: UINavigationController, with option: DeepLinkOption) {
        let router = Router(navigationController: navigationController)
        let coordinator = OrdersCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start(with: option)
    }
    
    private func startDealsCoordinator(navigationController: UINavigationController, with option: DeepLinkOption) {
        let router = Router(navigationController: navigationController)
        let coordinator = DealsCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start(with: option)
    }
    
}

// MARK: MainTabBarControllerDelegate
extension MainTabbarCoordinator: MainTabBarControllerDelegate {
    
    func selectMenuFlow(navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty == true {
            startMenuCoordinator(navigationController: navigationController)
        }
    }
    
    func selectCatalogFlow(navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty == true {
            startCatalogCoordinator(navigationController: navigationController)
        }
    }
    
    func shouldSelectCartFlow() -> Bool {
        guard authManager.currenUser != nil else {
            tabController.showAuthorizationAlert(doneAction: { [unowned self] in
                self.startAuthenticationCoordinator()
            })
            return false
        }
        
        return true
    }
    
    func selectCartFlow(navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty == true {
            startCartCoordinator(navigationController: navigationController)
        }
    }
    
    func selectHotCallFlow(navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty == true {
            startHotCallCoordinator(navigationController: navigationController)
        }
    }
    
    func selectChatFlow(navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty == true {
            startChatCoordinator(navigationController: navigationController)
        }
    }
    
}

// MARK: MenuCoordinatorDelegate
extension MainTabbarCoordinator: MenuCoordinatorDelegate {
    
    func userLogout() {
        delegate?.userLogout()
    }

    func userSelect(drugStore: DrugStore) {
        delegate?.userSelect(drugStore: drugStore)
    }
    
    func userSelect(city: City) {
        delegate?.userSelect(city: city)
    }
    
}

// MARK: CartCoordinatorDelegate
extension MainTabbarCoordinator: CartCoordinatorDelegate {
    
    func selectCatalog() {
        tabController.showCatalog()
    }
    
}

// MARK: AuthenticationCoordinatorDelegate
extension MainTabbarCoordinator: AuthenticationCoordinatorDelegate {
    
    func successLogin(user: AuthUserType, coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
        tabController.showCart()
    }
    
    func cancelLogint(coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
    }
    
    func finishFlow(coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
    }

}

// MARK: OrdersCoordinatorDelegate
extension MainTabbarCoordinator: OrdersCoordinatorDelegate {
    
    func finishFlow(coordinator: OrdersCoordinator) {
        removeChild(coordinator)
    }
    
}

// MARK: DealsCoordinatorDelegate
extension MainTabbarCoordinator: DealsCoordinatorDelegate {
    
    func finishFlow(coordinator: DealsCoordinator) {
        removeChild(coordinator)
    }

}
