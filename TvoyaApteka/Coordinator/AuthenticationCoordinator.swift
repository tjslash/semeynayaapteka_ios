//
//  AuthenticationCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift

protocol AuthenticationCoordinatorDelegate: class {
    func successLogin(user: AuthUserType, coordinator: AuthenticationCoordinator)
    func cancelLogint(coordinator: AuthenticationCoordinator)
}

class AuthenticationCoordinator: BaseCoordinator {
    
    // MARK: Public
    weak var delegate: AuthenticationCoordinatorDelegate?
    
    // MARK: Private
    private let innerRouter = Router(navigationController: UINavigationController())
    private let authManager = AuthManager.shared
    private let cartManager = CartManager.shared
    private let favoriteRepository: FavoriteStorageProtocol = UserDefaultsFavoriteStorage(storeKey: Const.localFavoriteStorageKey)
    
    override func start() {
        showLoginPage()
        router.present(innerRouter, animated: true)
    }
    
    private func showLoginPage() {
        let viewModel = LoginViewModel(authManager: authManager, favoriteRepository: favoriteRepository)
        viewModel.delegate = self
        let page = LoginViewController(viewModel: viewModel)
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(didTapCloseButton))
        page.navigationItem.leftBarButtonItem = cancelButton
        innerRouter.push(page, animated: false, completion: nil)
    }
    
    private func showPasswordRecovery() {
        let viewModel = PasswordRecoveryViewModel(authManager: authManager)
        viewModel.delegate = self
        let page = PasswordRecoveryViewController(viewModel: viewModel)
        innerRouter.push(page, animated: true, completion: nil)
    }
    
    private func showСodeVerification(passwordContainer: PasswordContainer) {
        let viewModel = СodeVerificationViewModel(passwordContainer: passwordContainer,
                                                   authManager: authManager,
                                                   favoriteRepository: favoriteRepository)
        viewModel.delegate = self
        let page = СodeVerificationViewController(viewModel: viewModel)
        innerRouter.push(page, animated: true, completion: nil)
    }
    
    private func showChangePasswordPage(for phone: String) {
        let viewModel = ChangePasswordViewModel(phone: phone, authManager: authManager)
        viewModel.delegate = self
        let page = ChangePasswordViewController(viewModel: viewModel)
        innerRouter.push(page, animated: true, completion: nil)
    }
    
    private func showRegistrationPage() {
        let viewModel = RegistrationViewModel(authManager: authManager)
        viewModel.delegate = self
        let page = RegistrationViewController(viewModel: viewModel)
        innerRouter.push(page, animated: true, completion: nil)
    }
    
    private func popToStartController(animated: Bool = true) {
        innerRouter.popToRootModule(animated: true)
    }
    
    @objc
    private func didTapCloseButton() {
        delegate?.cancelLogint(coordinator: self)
    }
    
    private func uploadCart() {
        cartManager.reloadCart()
    }
    
}

// MARK: - LoginViewModelDelegate
extension AuthenticationCoordinator: LoginViewModelDelegate {
    
    func didTapForgotButton() {
        showPasswordRecovery()
    }
    
    func didTapRegistration() {
        showRegistrationPage()
    }
    
    func loginSuccess(user: AuthUserType) {
        uploadCart()
        delegate?.successLogin(user: user, coordinator: self)
    }
    
}

// MARK: - СodeVerificationViewModelDelegate
extension AuthenticationCoordinator: СodeVerificationViewModelDelegate {
    
    func codeVerificationSuccess(user: AuthUserType) {
        uploadCart()
        delegate?.successLogin(user: user, coordinator: self)
    }
    
}

// MARK: - ChangePasswordViewModelDelegate
extension AuthenticationCoordinator: ChangePasswordViewModelDelegate {
    
    func changedPasswordSuccess() {
        popToStartController()
    }
    
}

// MARK: - PasswordRecoveryViewModelDelegate
extension AuthenticationCoordinator: PasswordRecoveryViewModelDelegate {
    
    func sendSMS(phone: String) {
        showChangePasswordPage(for: phone)
    }

}

// MARK: - RegistrationViewModelDelegate
extension AuthenticationCoordinator: RegistrationViewModelDelegate {

    func sendSms(passwordContainer: PasswordContainer) {
        showСodeVerification(passwordContainer: passwordContainer)
    }

}
