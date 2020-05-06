//
//  ProfileCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol ProfileCoordinatorDelegate: class {
    func finishFlow(coordinator: ProfileCoordinator)
    func userLogOut(coordinator: ProfileCoordinator)
}

class ProfileCoordinator: BaseCoordinator {
    
    // MARK: Public
    public weak var delegate: ProfileCoordinatorDelegate?
    
    // MARK: Private
    private let authManager = AuthManager.shared
    
    override func start() {
        guard let user = authManager.currenUser else {
            router.visibleViewController?.showAuthorizationAlert(cancelAction: { [unowned self] in
                self.delegate?.finishFlow(coordinator: self)
                }, doneAction: { [unowned self] in
                    self.startAuthenticationCoordinator()
            })
            return
        }
        
        showProfilePage(user: user)
    }
    
    private func startAuthenticationCoordinator() {
        let coordinator = AuthenticationCoordinator(router: self.router)
        coordinator.delegate = self
        self.appendChild(coordinator)
        coordinator.start()
    }
    
    private func showProfilePage(user: AuthUserType) {
        let viewModel = ProfileViewModel(user: user, authManager: authManager)
        viewModel.delegate = self
        let page = ProfileViewController(viewModel: viewModel)
        router.push(page, animated: true, completion: { [unowned self] in self.delegate?.finishFlow(coordinator: self) })
    }
    
}

// MARK: AuthenticationCoordinatorDelegate
extension ProfileCoordinator: AuthenticationCoordinatorDelegate {
    
    func successLogin(user: AuthUserType, coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
        showProfilePage(user: user)
    }
    
    func cancelLogint(coordinator: AuthenticationCoordinator) {
        router.dismissModule(animated: true, completion: nil)
        removeChild(coordinator)
    }
    
}

// MARK: ProfilePageDelegate
extension ProfileCoordinator: ProfileViewModelDelegate {
    
    func userLogOut() {
        delegate?.userLogOut(coordinator: self)
    }
    
}
