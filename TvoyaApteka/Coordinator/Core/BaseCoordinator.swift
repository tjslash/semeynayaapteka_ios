//
//  BaseCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 28.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

public class BaseCoordinator: Coordinator {
    
    var router: RouterType
    var childCoordinators: [Coordinator] = []
    
    required public init(router: RouterType) {
        self.router = router
    }
    
    public func start() {
        start(with: nil)
    }
    
    public func start(with option: DeepLinkOption?) {
        
    }
    
    /// Add only unique object
    public func appendChild(_ coordinator: Coordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }
        
        childCoordinators.append(coordinator)
        print("Coordinator: append \(coordinator) to \(self)")
    }
    
    public func removeChild(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            print("Coordinator: remove \(coordinator) from \(self)")
            break
        }
    }
    
    deinit {
        print("Coordinator: deinit \(self)")
    }

}

// MARK: - BaseViewControllerDelegate
extension BaseCoordinator: BaseViewControllerDelegate {
    
    func didSelectSearch() {
        startSearchCoordinator()
    }
    
}

// MARK: - SearchCoordinatorDelegate
extension BaseCoordinator: SearchCoordinatorDelegate {
    
    private func startSearchCoordinator() {
        let coordinator = SearchCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    func finishFlow(coordinator: SearchCoordinator) {
        removeChild(coordinator)
    }
    
}
