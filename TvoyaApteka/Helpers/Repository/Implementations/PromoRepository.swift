//
//  PromoRepository.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class PromoRepository: PromoRepositoryType {
    
    func getPromotions(count: Int, offset: Int, in city: City) -> Single<[Promotion]> {
        return ServerAPI.promo.getPromotionList(cityId: city.id, from: offset, count: count)
    }
    func getPromotion(id promotionId: Int, in city: City) -> Single<Promotion> {
        return ServerAPI.promo.getPromotion(cityId: city.id, promotionId: promotionId)
    }
    
}
