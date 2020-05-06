//
//  ConfigurationCityFlowCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol ConfigurationCityFlowCoordinatorDelegate: class {
    func userSelect(city: UserCity, coordinator: ConfigurationCityFlowCoordinator)
}

class ConfigurationCityFlowCoordinator: BaseCoordinator {
    
    weak var delegate: ConfigurationCityFlowCoordinatorDelegate?
    
    override func start() {
        showSelectRegionPage()
    }
    
    private func showSelectRegionPage() {
        let viewModel = ListRegionsViewModel()
        viewModel.delegate = self
        let viewController = ListRegionsViewController(viewModel: viewModel)
        router.push(viewController, animated: false, completion: nil)
    }
    
    private func showSelectCityPage(cities: [UserCity]) {
        let viewModel = ConfigurationListCitiesViewModel(cities: cities)
        viewModel.delegate = self
        let viewController = ListCitiesViewController(viewModel: viewModel)
        router.push(viewController, animated: true, completion: nil)
    }
    
}

// MARK: - RegionsPageDelegate
extension ConfigurationCityFlowCoordinator: ListRegionsViewModelDelegate {
    
    func userSelectRegion(with cities: [UserCity]) {
        showSelectCityPage(cities: cities)
    }
    
}

// MARK: - CitiesPageDelegate
extension ConfigurationCityFlowCoordinator: ListCitiesViewModelDelegate {
    
    func userSelect(city: UserCity?) {
        delegate?.userSelect(city: city!, coordinator: self)
    }
    
}
