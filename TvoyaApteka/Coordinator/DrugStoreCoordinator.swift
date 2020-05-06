//
//  StoreCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol StoreCoordinatorDelegate: class {
    func finishFlow(coordinator: DrugStoreCoordinator)
}

class DrugStoreCoordinator: BaseCoordinator {
    
    public weak var delegate: StoreCoordinatorDelegate?
    
    override func start() {
        showListStoresPage()
    }
    
    private func showListStoresPage() {
        let viewModel = DrugStoresViewModel(locationManager: LocationManager(), drugStoreRepository: DrugStoreRepository())
        let viewController = DrugStoresViewController(viewModel: viewModel)
        viewController.delegate = self
        router.push(viewController, animated: true, completion: { [unowned self] in self.delegate?.finishFlow(coordinator: self) })
    }
    
    private func showStoreDetailsPage(id: Int) {
        let viewModel = DrugStoreDetailsViewModel(storeId: id, drugStoreRepository: DrugStoreRepository())
        let viewController = DrugStoreDetailsViewController(viewModel: viewModel)
        viewController.delegate = self
        router.push(viewController, animated: true, completion: nil)
    }
}

// MARK: - StoresPageDelegate
extension DrugStoreCoordinator: DrugStoresViewControllerDelegate {
    
    func userSelect(store: DrugStore) {
        showStoreDetailsPage(id: store.id)
    }
}
