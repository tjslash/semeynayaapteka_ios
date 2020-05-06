//
//  FlatTextField+Rx.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: FlatTextField {
    
    var errorMessage: Binder<String?> {
        return Binder<String?>.init(self.base, binding: { input, message in
            input.errorMessage = message
        })
    }
    
}
