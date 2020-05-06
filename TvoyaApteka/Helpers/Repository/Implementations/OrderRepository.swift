//
//  OrderRepository.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class OrderRepository: OrderRepositoryType {
    
    func getOrders(for user: AuthUserType, withStatus status: Order.State?) -> Single<[Order]> {
        return user.getToken()
            .flatMap({ token in
                ServerAPI.order.getAllOrders(token: token, withStatus: status)
            })
    }
    
    func getOrder(id orderId: Int, for user: AuthUserType) -> Single<Order> {
        return user.getToken()
            .flatMap({ token in
                ServerAPI.order.getOrder(token: token, orderId: orderId)
            })
    }
    
    func cancelOrder(id orderId: Int, for user: AuthUserType) -> Completable {
        return user.getToken()
            .flatMapCompletable({ token in
                ServerAPI.order.cancelOrder(token: token, orderId: orderId)
            })
    }
    
}
