//
//  Service.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 11.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

class ServerAPI {
    static let actual: ActualsAPIProtocol = ActualAPI()
    static let favorite: FavoritesAPIProtocol = FavoritesAPI()
    static let article: ArticleAPIProtocol = ArticleAPI()
    static let promo: PromoAPIProtocol = PromoAPI()
    static let bonusCard: BonusCardAPIProtocol = BonusCardAPI()
    static let cities: CitiesAPIProtocol = CitiesAPI()
    static let drug: DrugAPIProtocol = DrugAPI()
    static let drugStore: DrugStoresAPIProtocol = DrugStoreAPI()
    static let drugCategory: DrugCategoriesAPIProtocol = DrugCategoriesAPI()
    static let cart: CartAPIProtocol = CartAPI()
    static let order: OrdersAPIProtocol = OrdersAPI()
    static let user: UserAPIProtocol = UserAPI()
    static let search: SearchAPIProtocol = SearchAPI()
    static let feedback: FeedbackAPIProtocol = FeedbackAPI()
    static let deviceToken: DeviceTokenAPIProtocol = DeviceTokenAPI()
}
