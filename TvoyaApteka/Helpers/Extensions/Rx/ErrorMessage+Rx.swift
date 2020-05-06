//
//  ErrorMessage+Rx.swift
//  TvoyaApteka
//
//  Created by BuidMac on 01.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var showMessage: Binder<String> {
        return Binder<String>.init(self.base, binding: { _, textError in
            ErrorPresenter.showError(text: textError)
        })
    }
    
}
