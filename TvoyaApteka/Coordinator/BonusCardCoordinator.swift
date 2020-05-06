//
//  BonusCardCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol BonusCardCoordinatorDelegate: class {
    func finishFlow(coordinator: BonusCardCoordinator)
}

class BonusCardCoordinator: BaseCoordinator {
    
    // MARK: Public
    public weak var delegate: BonusCardCoordinatorDelegate?
    
    // MARK: Private
    private let authManager = AuthManager.shared
    
    override func start() {
        guard let currenUser = authManager.currenUser else {
            router.visibleViewController?.showAuthorizationAlert(cancelAction: { [unowned self] in
                self.delegate?.finishFlow(coordinator: self)
                }, doneAction: { [unowned self] in
                    self.startAuthenticationCoordinator()
            })
            return
        }
        
        showBonusCardPage(user: currenUser)
    }
    
    private func startAuthenticationCoordinator() {
        let coordinator = AuthenticationCoordinator(router: router)
        coordinator.delegate = self
        appendChild(coordinator)
        coordinator.start()
    }
    
    private func showBonusCardPage(user: AuthUserType) {
        let page = BonusCardViewController(user: user)
        page.delegate = self
        router.push(page, animated: true, completion: { [unowned self] in self.delegate?.finishFlow(coordinator: self) })
    }
    
}

// MARK: AuthenticationCoordinatorDelegate
extension BonusCardCoordinator: AuthenticationCoordinatorDelegate {
    
    func successLogin(user: AuthUserType, coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
        showBonusCardPage(user: user)
    }
    
    func cancelLogint(coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
    }
    
}
