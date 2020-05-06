//
//  BonusCardService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 30.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class BonusCardAPI: BonusCardAPIProtocol {
    
    private let adapter = NetworkAdapter<BonusCardRequest>()
    
    func getBonusCard(token: String) -> Single<BonusCard> {
        return adapter.send(request: .getBonusCard(token: token))
            .mapObject(to: BonusCard.self, keyPath: "data")
    }
    
    func activateBonusCard(token: String, cardNum: String) -> Completable {
        let request = BonusCardRequest.activateBonusCard(token: token, cardNum: cardNum)
        return adapter.send(request: request)
            .asCompletable()
    }
    
}
