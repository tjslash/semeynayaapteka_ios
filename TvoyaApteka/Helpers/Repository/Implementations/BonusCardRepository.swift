//
//  BonusCardRepository.swift
//  TvoyaApteka
//
//  Created by BuidMac on 04.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class BonusCardRepository: BonusCardRepositoryType {
    
    func getBonusCard(for user: AuthUserType) -> Single<BonusCard> {
        return user.getToken()
            .flatMap({ token in
                ServerAPI.bonusCard.getBonusCard(token: token)
            })
    }
    
    func activeBonusCard(for user: AuthUserType, num: String) -> Completable {
        return user.getToken()
            .flatMapCompletable({ token in
                ServerAPI.bonusCard.activateBonusCard(token: token, cardNum: String(num))
            })
    }

}
