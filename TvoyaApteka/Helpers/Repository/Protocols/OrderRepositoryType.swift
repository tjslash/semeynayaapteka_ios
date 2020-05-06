//
//  OrderRepositoryType.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

protocol OrderRepositoryType {
    func getOrders(for user: AuthUserType, withStatus status: Order.State?) -> Single<[Order]>
    func getOrder(id orderId: Int, for user: AuthUserType) -> Single<Order>
    func cancelOrder(id orderId: Int, for user: AuthUserType) -> Completable
}
