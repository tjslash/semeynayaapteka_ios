//
//  PromoCodeView+Rx.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: PromoCodeView {
        
    var promoState: Binder<PromoCodeView.PromoStates> {
        return Binder<PromoCodeView.PromoStates>.init(self.base, binding: { view, state in
            view.promoState = state
        })
    }
    
    var promoCode: Binder<String?> {
        return Binder<String?>.init(self.base, binding: { view, code in
            view.promoText = code
        })
    }
    
}
