//
//  CarttService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 02.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift

class CartAPI: CartAPIProtocol {
    
    private let adapter = NetworkAdapter<CartRequest>()
    
    func getCart(token: String, cityId: Int, promocode: String?) -> Single<Cart> {
        return adapter.send(request: .getCart(token: token, cityId: cityId, promocode: promocode))
            .mapObject(to: Cart.self, keyPath: "data")
    }
    
    func addToCart(token: String, drugStoreId: Int, drugId: Int, count: Int) -> Completable {
        let request = CartRequest.addToCart(token: token, drugStoreId: drugStoreId, drugId: drugId, count: count)
        return adapter.send(request: request)
            .asCompletable()
    }
    
    func deleteFromCart(drugStoreId: Int, drugId: Int, count: UInt) -> Completable {
        let request = CartRequest.deleteFromCart(drugStoreId: drugStoreId, drugId: drugId, count: count)
        return adapter.send(request: request)
            .asCompletable()
    }
    
    func deleteTradeFromCart(token: String, drugsId: [Int]) -> Completable {
        let request = CartRequest.deleteTradeFromCart(token: token, drugsId: drugsId)
        return adapter.send(request: request)
            .asCompletable()
    }
    
}
