//
//  BaseViewController+Rx.swift
//  TvoyaApteka
//
//  Created by BuidMac on 01.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: BaseViewController {
    
    var showPreloader: Binder<Bool> {
        return Binder<Bool>.init(self.base, binding: { viewController, isLoading in
            isLoading ? viewController.showPreloader() : viewController.hidePreloader()
        })
    }
    
    var showNotConnection: Binder<() -> Void> {
        return Binder<() -> Void>.init(self.base, binding: { viewController, reconectCallBack in
            let childViewController = NotConnectionViewController(reconectCallback: reconectCallBack)
            viewController.add(childViewController)
        })
    }
    
}
