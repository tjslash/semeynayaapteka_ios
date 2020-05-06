//
//  CartManager.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CartManagerType {
    var cart: Variable<Cart> { get }
    
    func apply(promocode: String) -> Single<Cart>
    func reloadCart()
    func getDrug(id: Int) -> Cart.Item?
    func add(id: Int, storeId: Int, count: Int) -> Completable
    func delete(id: Int) -> Completable
    func makeOrder() -> Single<[Order]>
    func cancelOrder() -> Completable
    func clear()
}

class CartManager: CartManagerType {
    
    // MARK: Public
    public static let shared: CartManagerType = CartManager()
    
    public let cart = Variable<Cart>(Cart())
    
    // MARK: Private
    
    private var currentUser: AuthUserType {
        return AuthManager.shared.currenUser!
    }
    
    private var cityId: Int {
        return AppConfiguration.shared.currentCity?.id ?? 8
    }
    
    private init() {}
    
    // MARK: Public metods
    
    func apply(promocode: String) -> Single<Cart> {
        return currentUser.getToken()
            .flatMap({ [unowned self] token in
                ServerAPI.cart.getCart(token: token, cityId: self.cityId, promocode: promocode)
            })
            .do(onSuccess: { [unowned self] cart in
                cart.promocode = PromoCode(code: promocode)
                self.cart.value = cart
            })
    }
    
    func add(id: Int, storeId: Int, count: Int) -> Completable {
        return currentUser.getToken()
            .flatMapCompletable({ [unowned self] token in
                ServerAPI.cart.deleteTradeFromCart(token: token, drugsId: [id])
                    .andThen(ServerAPI.cart.addToCart(token: token, drugStoreId: storeId, drugId: id, count: count))
                    .andThen(self.uploadCart())
                    .asCompletable()
            })
    }
    
    func delete(id: Int) -> Completable {
        return currentUser.getToken()
            .flatMapCompletable({ [unowned self] token in
                ServerAPI.cart.deleteTradeFromCart(token: token, drugsId: [id])
                    .andThen(self.uploadCart())
                    .asCompletable()
            })
    }
    
    func makeOrder() -> Single<[Order]> {
        return currentUser.getToken()
            .flatMap({ token in
                ServerAPI.order.createOrderFromCart(token: token, promocode: self.cart.value.promocode?.code)
            })
            .do(onSuccess: { [unowned self] _ in
                self.clear()
            })
    }
    
    func cancelOrder() -> Completable {
        let drugsId = cart.value.items.map { $0.drug.id }
        
        return currentUser.getToken()
            .flatMapCompletable({ [unowned self] token in
                ServerAPI.cart.deleteTradeFromCart(token: token, drugsId: drugsId)
                    .andThen(self.uploadCart())
                    .asCompletable()
            })
    }
    
    func getDrug(id: Int) -> Cart.Item? {
        return cart.value.items.first(where: { $0.drug.id == id })
    }
    
    func clear() {
        cart.value = Cart()
    }
    
    private let bag = DisposeBag()
    func reloadCart() {
        clear()
        
        uploadCart()
            .subscribe()
            .disposed(by: bag)
    }
    
    // MARK: Private metods
    
    private func uploadCart() -> Single<Cart> {
        return currentUser.getToken()
            .flatMap({ [unowned self] token in
                ServerAPI.cart.getCart(token: token, cityId: self.cityId, promocode: nil)
            })
            .do(onSuccess: { [unowned self] cart in
                self.cart.value = cart
            })
    }
    
    private func handleError(_ error: Error) {
        guard let serviceError = error as? ServiceError else {
            return
        }
        
        switch serviceError {
        case .notFound, .alreadyUsed:
            let cart = self.cart.value
            cart.promocode = nil
            self.cart.value = cart
        default:
            break
        }
    }
    
}
