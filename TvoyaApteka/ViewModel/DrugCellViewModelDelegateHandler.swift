//
//  DrugCellViewModelDelegateHandler.swift
//  TvoyaApteka
//
//  Created by BuidMac on 01.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol DrugCellViewModelDelegateHandler {
    var showRecipeAlert: ((_ handler: @escaping () -> Void) -> Void)? { get set }
    var showCount: ((_ min: Int, _ max: Int, _ handler: @escaping (_ selectCount: Int) -> Void) -> Void)? { get set }
    var notAuthorization: (() -> Void)? { get set }
    
    func showErrorMessage(_ error: Error)
}

extension DrugCellViewModelDelegateHandler {
    
    func showError(error: Error) {
        showErrorMessage(error)
    }
    
    func showAuthorizationAlert() {
        notAuthorization?()
    }
    
    func showRecipeAlert(successHandler: @escaping () -> Void) {
        showRecipeAlert?(successHandler)
    }
    
    func showCount(min: Int, max: Int, successHandler: @escaping (Int) -> Void) {
        showCount?(min, max, successHandler)
    }
    
}
