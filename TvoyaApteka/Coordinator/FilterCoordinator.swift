//
//  FilterCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 28.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol FilterCoordinatorDelegate: class {
    func finishFlow(coordinator: FilterCoordinator, filter: DrugFilter?)
}

class FilterCoordinator: BaseCoordinator {
    
    weak var delegate: FilterCoordinatorDelegate?
    
    override func start() {
        showFilterPage()
    }
    
    private func showFilterPage() {
        let page = FilterViewController(drugRepository: DrugRepository())
        page.delegate = self
        page.loadFilter()
        router.push(page, animated: true) { [unowned self] in
            self.delegate?.finishFlow(coordinator: self, filter: nil)
        }
    }
    
}

// MARK: - FilterPageDelegate
extension FilterCoordinator: FilterViewControllerDelegate {
    
    func applyDrugFilter(_ filter: DrugFilter) {
        router.popModule(animated: false)
        delegate?.finishFlow(coordinator: self, filter: filter)
    }
    
}
