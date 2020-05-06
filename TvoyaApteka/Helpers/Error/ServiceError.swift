//
//  ServiceError.swift
//  TvoyaApteka
//
//  Created by BuidMac on 19.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case jsonParseFail
    case unexpectedServerCode
    case validation(message: ServerBagErrors)
    case notAuthorized(message: ServerBagErrors)
    case serverError(message: ServerBagErrors)
    case alreadyUsed(message: ServerBagErrors)
    case notFound(message: ServerBagErrors)
    case noConnectionToServer
    case userCityNotDefined
}

enum ConnectionError: Error {
    case noConnectionToServer
}

enum ParseServerJsonError: Error {
    case jsonParseFail
}
