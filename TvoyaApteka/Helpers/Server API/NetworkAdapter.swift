//
//  NetworkAdapter.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import RxSwift
import Moya

class NetworkAdapter<T: TargetType> {
    
    private let pluginsFabric = PluginFabric()
    private var provider: MoyaProvider<T>!
    private let bag = DisposeBag()
    
    init() {
        self.provider = MoyaProvider<T>(plugins: pluginsFabric.makePlugins())
    }
    
    func send(request token: T) -> Single<Response> {
        return provider.rx.request(token)
            .catchError { error in
                return Single.error(ServiceError.noConnectionToServer)
            }
            .flatMap { response in
                if response.containSuccessfulCode() {
                    return Single.just(response)
                } else {
                    let serviceError = ErrorParser.parse(from: response.data, code: response.statusCode)
                    return Single.error(serviceError)
                }
            }
    }
    
}

fileprivate extension Response {
    
    func containSuccessfulCode() -> Bool {
        return statusCode >= 200 && statusCode <= 299
    }
    
}
