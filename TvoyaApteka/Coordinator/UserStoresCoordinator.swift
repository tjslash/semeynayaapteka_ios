//
//  UserStoresCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol UserStoresCoordinatorDelegate: class {
    func userSelect(drugStore: DrugStore?, coordinator: UserStoresCoordinator)
}

class UserStoresCoordinator: BaseCoordinator {
    
    public weak var delegate: UserStoresCoordinatorDelegate?
    
    override func start() {
        showListUserStorePage()
    }
    
    private func showListUserStorePage() {
        let viewModel = ListUserDrugStoresViewModel(drugStoreRepository: DrugStoreRepository())
        viewModel.delegate = self
        let viewController = ListUserDrugStoresViewController(viewModel: viewModel)
        router.push(viewController, animated: true, completion: { [unowned self] in
            self.delegate?.userSelect(drugStore: nil, coordinator: self)
        })
    }
    
}

// MARK: - ListUserStoresViewModelDelegate
extension UserStoresCoordinator: ListUserDrugStoresViewModelDelegate {
    
    func userSelect(store: DrugStore) {
        delegate?.userSelect(drugStore: store, coordinator: self)
    }
    
}
