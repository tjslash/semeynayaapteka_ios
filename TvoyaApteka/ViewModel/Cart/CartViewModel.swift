//
//  CartViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CartViewModel {
    
    // MARK: Input
    let promoCode = Variable<String>("")
    let buyButtonDidTap = PublishSubject<Void>()
    
    // MARK: Output
    let isLoading: Driver<Bool>
    let cart: Driver<Cart>
    let promocode: Driver<String?>
    let promocodeInputIsUserInteractionEnabled: Driver<Bool>
    let promoCodeState: Driver<PromoCodeView.PromoStates>
    let hasStrictRecipeDrugs: Driver<Bool>
    let makeOrderSuccess = PublishSubject<[Order]>()
    let messagesError = PublishSubject<String>()
    
    // MARK: Private
    private let errorFabric = ErrorMessageFabric()
    private let activityIndicator = ActivityIndicator()
    private let cartManager: CartManagerType
    private let bag = DisposeBag()
    
    init(cartManager: CartManagerType) {
        self.cartManager = cartManager
        
        isLoading = activityIndicator
            .asDriver()
        
        cart = cartManager
            .cart
            .asDriver()
        
        promocode = cartManager
            .cart
            .asDriver()
            .map({ $0.promocode?.code })
        
        hasStrictRecipeDrugs = cartManager
            .cart
            .asDriver()
            .map({ $0.hasStrictRecipeTrades })
        
        promoCodeState = cartManager
            .cart
            .asDriver()
            .map({ $0.promocode != nil })
            .map({ isActive -> PromoCodeView.PromoStates in
                return isActive ? .activated : .start
            })
        
        promocodeInputIsUserInteractionEnabled = promoCodeState
            .map({ $0 == .start })
        
        buyButtonDidTap
            .bind(onNext: { [unowned self] _ in
                self.makeOrder()
            })
            .disposed(by: bag)
    }
    
    func applyPromoCode() {
        guard !promoCode.value.isEmpty else { return }
        
        cartManager.apply(promocode: promoCode.value)
            .trackActivity(activityIndicator)
            .asSingle()
            .subscribe(onError: { [weak self] error in
                self?.showErrorMessage(error)
            })
            .disposed(by: bag)
    }
    
    private func makeOrder() {
        cartManager.makeOrder()
            .trackActivity(activityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] orders in
                self?.makeOrderSuccess.onNext(orders)
            }, onError: { [weak self] error in
                self?.showErrorMessage(error)
            }).disposed(by: bag)
    }
    
    private func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            self.messagesError.onNext(textError)
        }
    }
 
    deinit {
        print("Deinit \(self)")
    }
    
}
