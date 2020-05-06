//
//  RootCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift

class RootCoordinator: BaseCoordinator {
    
    // MARK: Private
    private let bag = DisposeBag()
    private let appConfiguration = AppConfiguration.shared
    private let deviceTokenService = DeviceTokenService(api: ServerAPI.deviceToken)
    
    override func start() {
        if appConfiguration.currentCity == nil {
            startCityFlowCoordinator()
            return
        }
        
        if UIApplication.shared.isFirstLaunch {
            showOnBoardingPage()
            return
        }
        
        if AuthManager.shared.currenUser != nil {
            CartManager.shared.reloadCart()
        }
        
        showInitialDataPage(for: appConfiguration.currentCity!, then: startTabBarFlow)
    }
    
    override func start(with option: DeepLinkOption?) {
        childCoordinators.forEach({ $0.start(with: option) })
    }
    
    // MARK: Private functions
    private func showInitialDataPage(for userCity: City, then handler: @escaping () -> Void ) {
        let viewController = LoadInitialDataViewController(userCity, completion: { [unowned self] in
            self.router.dismissModule(animated: false, completion: handler)
        })
        
        let navController = UINavigationController(rootViewController: viewController)
        router.present(navController, animated: false)
    }
    
    private func restart() {
        router.setRootModule(UIViewController(), hideBar: false)
        childCoordinators.removeAll()
        start()
    }
    
    // MARK: Coordinators
    private func startCityFlowCoordinator() {
        let coordinator = CityFlowCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func startTabBarFlow() {
        let coordinator = MainTabbarCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    // MARK: Pages
    private func showOnBoardingPage() {
        let viewController = OnBoardingViewController()
        viewController.delegate = self
        router.present(viewController, animated: false)
    }

}

// MARK: - OnBoardingPageDelegate
extension RootCoordinator: OnBoardingViewControllerDelegate {
    
    func finishShowing() {
        UIApplication.shared.isFirstLaunch = false
        router.dismissModule(animated: false, completion: nil)
        start()
    }
    
}

// MARK: - CityFlowCoordinatorDelegate
extension RootCoordinator: CityFlowCoordinatorDelegate {
    
    func userSelect(city: City?, coordinator: CityFlowCoordinator) {
        if let city = city {
            appConfiguration.currentCity = city
            removeChild(coordinator)
            start()
        } else {
            fatalError("User mast select current city!")
        }
    }

}

// MARK: - MainTabBarControllerDelegate
extension RootCoordinator: MainTabbarCoordinatorDelegate {
    
    func userLogout() {
        CartManager.shared.clear()
        deviceTokenService.removeCurrentDeviceToken()
        restart()
    }
    
    func userSelect(drugStore: DrugStore) {
        appConfiguration.favoriteDrugStore.value = drugStore
    }
    
    func userSelect(city: City) {
        DrugStoreRepository.clearCache()
        appConfiguration.currentCity = city
        appConfiguration.favoriteDrugStore.value = nil
        restart()
    }
    
}
