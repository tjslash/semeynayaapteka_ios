//
//  MenuCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 25.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

protocol MenuCoordinatorDelegate: class {
    func selectCatalog()
    func userSelect(city: City)
    func userSelect(drugStore: DrugStore)
    func userLogout()
}

class MenuCoordinator: BaseCoordinator {
    
    // MARK: Public
    public weak var delegate: MenuCoordinatorDelegate?
    
    // MARK: Private
    private let authManaget = AuthManager.shared
    
    override func start() {
        let page = MenuViewController()
        page.delegate = self
        router.push(page, animated: false, completion: nil)
    }
    
    deinit {
        print("Deinit")
    }
    
    // MARK: Coordinators
    private func startCityFlowCoordinator() {
        let coordinator = CityFlowCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startUserStoresCoordinator() {
        let coordinator = UserStoresCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startOrdersCoordinator() {
        let coordinator = OrdersCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startFavoriteCoordinator() {
        let coordinator = FavoriteCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startBonusCardCoordinator() {
        let coordinator = BonusCardCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
//    private func startDealsCoordinator() {
//        let coordinator = DealsCoordinator(router: router)
//        coordinator.delegate = self
//        appendChild(coordinator)
//        coordinator.start()
//    }
    
    private func startExperementalDealsCoordinator() {
        let coordinator = EDealsCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startNewsCoordinator() {
        let coordinator = NewsCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startProfileCoordinator() {
        let coordinator = ProfileCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startStoreCoordinator() {
        let coordinator = DrugStoreCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startReviewCoordinator() {
        let coordinator = ReviewCoordinator(router: router, user: authManaget.currenUser)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
}

// MARK: MenuPageDelegate
extension MenuCoordinator: MenuViewControllerDelegate {
    
    func selectChangeCity() {
        startCityFlowCoordinator()
    }
    
    func selectChangeStore() {
        startUserStoresCoordinator()
    }
    
    func selectCatalog() {
        delegate?.selectCatalog()
    }
    
    func selectListOrders() {
        startOrdersCoordinator()
    }
    
    func selectFavoriteDrug() {
        startFavoriteCoordinator()
    }
    
    func selectBonusCard() {
        startBonusCardCoordinator()
    }
    
    func selectListDeals() {
//        startDealsCoordinator()
        startExperementalDealsCoordinator()
    }
    
    func selectListNews() {
        startNewsCoordinator()
    }
    
    func selectProfile() {
        startProfileCoordinator()
    }
    
    func selectListStore() {
        startStoreCoordinator()
    }
    
    func selectReview() {
        startReviewCoordinator()
    }
    
}

// MARK: CityFlowCoordinatorDelegate
extension MenuCoordinator: CityFlowCoordinatorDelegate {
    func userSelect(city: City?, coordinator: CityFlowCoordinator) {
        removeChild(coordinator)
        router.popToRootModule(animated: true)
        
        if let city = city {
            delegate?.userSelect(city: city)
        }
    }

}

extension MenuCoordinator: UserStoresCoordinatorDelegate {
    
    func userSelect(drugStore: DrugStore?, coordinator: UserStoresCoordinator) {
        removeChild(coordinator)
        router.popToRootModule(animated: true)
        
        if let drugStore = drugStore {
            delegate?.userSelect(drugStore: drugStore)
        }
    }

}

// MARK: DealsCoordinatorDelegate
//extension MenuCoordinator: DealsCoordinatorDelegate {
//    
//    func finishFlow(coordinator: DealsCoordinator) {
//        removeChild(coordinator)
//        router.popToRootModule(animated: true)
//    }
//    
//}

// MARK: EDealsCoordinatorDelegate
extension MenuCoordinator: EDealsCoordinatorDelegate {
    
    func finishFlow(coordinator: EDealsCoordinator) {
        removeChild(coordinator)
        router.popToRootModule(animated: true)
    }
    
}

// MARK: OrdersCoordinatorDelegate
extension MenuCoordinator: OrdersCoordinatorDelegate {
    
    func finishFlow(coordinator: OrdersCoordinator) {
        removeChild(coordinator)
        router.popToRootModule(animated: true)
    }
    
}

// MARK: BonusCardCoordinatorDelegate
extension MenuCoordinator: BonusCardCoordinatorDelegate {
    
    func finishFlow(coordinator: BonusCardCoordinator) {
        removeChild(coordinator)
        router.popToRootModule(animated: true)
    }
    
}

// MARK: NewsCoordinatorDelegate
extension MenuCoordinator: NewsCoordinatorDelegate {
    
    func finishFlow(coordinator: NewsCoordinator) {
        removeChild(coordinator)
        router.popToRootModule(animated: true)
    }
    
}

// MARK: ProfileCoordinatorDelegate
extension MenuCoordinator: ProfileCoordinatorDelegate {
    
    func userLogOut(coordinator: ProfileCoordinator) {
        removeChild(coordinator)
        delegate?.userLogout()
    }
    
    func finishFlow(coordinator: ProfileCoordinator) {
        removeChild(coordinator)
        router.popToRootModule(animated: true)
    }
    
}

// MARK: StoreCoordinatorDelegate
extension MenuCoordinator: StoreCoordinatorDelegate {
    
    func finishFlow(coordinator: DrugStoreCoordinator) {
        removeChild(coordinator)
        router.popToRootModule(animated: true)
    }
    
}

// MARK: ReviewCoordinatorDelegate
extension MenuCoordinator: ReviewCoordinatorDelegate {
    
    func finishFlow(coordinator: ReviewCoordinator) {
        removeChild(coordinator)
        router.popToRootModule(animated: true)
    }
    
}

extension MenuCoordinator: FavoriteCoordinatorDelegate {
    
    func finishFlow(coordinator: FavoriteCoordinator) {
        removeChild(coordinator)
        router.popToRootModule(animated: true)
    }
    
}
