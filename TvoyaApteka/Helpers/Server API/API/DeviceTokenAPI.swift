//
//  DeviceTokenService.swift
//  TvoyaApteka
//
//  Created by BuidMac on 16.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class DeviceTokenAPI: DeviceTokenAPIProtocol {
    
    private let adapter = NetworkAdapter<DeviceTokenRequest>()
    
    func send(token: String, pushToken: String) -> Completable {
        let request = DeviceTokenRequest.send(token: token, pushToken: pushToken)
        return adapter.send(request: request)
            .asCompletable()
    }
    
}
