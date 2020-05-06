//
//  PromoRepositoryType.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

protocol PromoRepositoryType {
    func getPromotions(count: Int, offset: Int, in city: City) -> Single<[Promotion]>
    func getPromotion(id promotionId: Int, in city: City) -> Single<Promotion>
}
