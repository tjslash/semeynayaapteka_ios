//
//  OrdersService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 02.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift

class OrdersAPI: OrdersAPIProtocol {
    
    private let adapter = NetworkAdapter<OrderRequest>()
    
    func getAllOrders(token: String, withStatus: Order.State?) -> Single<[Order]> {
        return adapter.send(request: .getOrders(token: token, orderStatus: withStatus?.rawValue))
            .mapArray(to: Order.self, keyPath: "data")
    }
    
    func cancelOrder(token: String, orderId: Int) -> Completable {
        let request = OrderRequest.cancelOrder(token: token, orderId: orderId)
        return adapter.send(request: request)
            .asCompletable()
    }
    
    func getOrder(token: String, orderId: Int) -> Single<Order> {
        return adapter.send(request: .getOrder(token: token, orderId: orderId))
            .mapObject(to: Order.self, keyPath: "data")
    }
    
    func createOrderFromCart(token: String, promocode: String?) -> Single<[Order]> {
        return adapter.send(request: .createOrderFromCart(token: token, promocode: promocode))
            .mapArray(to: Order.self, keyPath: "data")
    }
    
}
