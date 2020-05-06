//
//  ErrorMessageFabric.swift
//  TvoyaApteka
//
//  Created by BuidMac on 19.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

class ErrorMessageFabric {
    
    func getMessage(form error: Error) -> String? {
        guard let serviceError = error as? ServiceError else { return nil }
        
        switch serviceError {
        case .jsonParseFail:
            return "Ошибка обработки ответа"
        case .userCityNotDefined:
            return "Не задан город пользователя"
        case .noConnectionToServer:
            return "Нет подключения к серверу, проверьте соединение с интернетом"
        case .notFound(message: let bag):
            return getFirstError(from: bag)
        case .validation(let bag):
            return getFirstError(from: bag)
        case .notAuthorized(let bag):
            return getFirstError(from: bag)
        case .serverError(let bag):
            return getFirstError(from: bag)
        case .alreadyUsed(let bag):
            return getFirstError(from: bag)
        default:
            return "Неизвестная ошибка сервера"
        }
    }
    
    private func getFirstError(from bag: ServerBagErrors) -> String {
        return bag.errors.firstMessage ?? "Неизвестная ошибка сервера"
    }
    
}
