//
//  PromoService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 29.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class PromoAPI: PromoAPIProtocol {
    
    private let adapter = NetworkAdapter<PromoRequest>()
    
    func getPromotionList(cityId: Int, from: Int, count: Int) -> Single<[Promotion]> {
        guard from >= 0, count >= 0 else { return Single.just([]) }
        return adapter.send(request: .getPromotionList(inCity: cityId, from: from, count: count))
            .mapArray(to: Promotion.self, keyPath: "data")
    }
    
    func getPromotion(cityId: Int, promotionId: Int) -> Single<Promotion> {
        return adapter.send(request: .promo(inCity: cityId, id: promotionId))
            .mapObject(to: Promotion.self, keyPath: "data")
    }
    
}
