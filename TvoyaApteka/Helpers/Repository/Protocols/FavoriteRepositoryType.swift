//
//  FavoriteRepositoryType.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

protocol FavoriteRepositoryType {
    func add(id: Int) -> Completable
    func get(count: Int, offset: Int, for userCity: City) -> Single<[Drug]>
    func delete(id: Int) -> Completable
    func isExists(userCity: City, id: Int) -> Single<Bool>
}
