//
//  BonusCardRepositoryType.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

protocol BonusCardRepositoryType {
    func getBonusCard(for user: AuthUserType) -> Single<BonusCard>
    func activeBonusCard(for user: AuthUserType, num: String) -> Completable
}
