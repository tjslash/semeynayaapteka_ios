//
//  CityFlowCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 21.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

protocol CityFlowCoordinatorDelegate: class {
    func userSelect(city: City?, coordinator: CityFlowCoordinator)
}

class CityFlowCoordinator: BaseCoordinator {

    // MARK: Public
    weak var delegate: CityFlowCoordinatorDelegate?
    
    // MARK: Private
    private let repository: CitiesRepositoryType = CitiesRepository()
    
    override func start() {
        showSelectRegionPage()
    }
    
    private func showSelectRegionPage() {
        let viewModel = ListRegionsViewModel(repository: repository)
        viewModel.delegate = self
        let viewController = ListRegionsViewController(viewModel: viewModel)
        
        router.push(viewController, animated: true, completion: { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.userSelect(city: nil, coordinator: strongSelf)
            }
        })
    }
    
    private func showSelectCityPage(cities: [City]) {
        let viewModel = ListCitiesViewModel(cities: cities, cartManager: CartManager.shared)
        viewModel.delegate = self
        let viewController = ListCitiesViewController(viewModel: viewModel)
        router.push(viewController, animated: true, completion: nil)
    }
    
}

// MARK: - RegionsPageDelegate
extension CityFlowCoordinator: ListRegionsViewModelDelegate {
    
    func userSelectRegion(with cities: [City]) {
        showSelectCityPage(cities: cities)
    }
    
}

// MARK: - CitiesPageDelegate
extension CityFlowCoordinator: ListCitiesViewModelDelegate {
    
    func userSelect(city: City?) {
        delegate?.userSelect(city: city, coordinator: self)
    }

}
