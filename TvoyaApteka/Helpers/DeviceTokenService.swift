//
//  DeviceTokenService.swift
//  TvoyaApteka
//
//  Created by BuidMac on 17.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import Firebase
import FirebaseMessaging

class DeviceTokenService {
  
    // MARK: Private
    private let api: DeviceTokenAPIProtocol
    
    init(api: DeviceTokenAPIProtocol) {
        self.api = api
    }
    
    // MARK: Public
    
    func removeCurrentDeviceToken() {
        InstanceID.instanceID().deleteID { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func sendCurrentDeviceToken(user: AuthUserType) {
        getCurrentDeviceToken()
            .flatMapCompletable({ deviceToken in
                user.getToken()
                    .flatMapCompletable({ [unowned self] token in
                        self.sendDeviceToken(userToken: token, deviceToken: deviceToken)
                    })
            })
            .subscribe()
            .dispose()
    }

}

extension DeviceTokenService {
    
    private func getCurrentDeviceToken() -> Single<String> {
        return Single<String>.create(subscribe: { observable in
            InstanceID.instanceID().instanceID { result, error in
                if let result = result {
                    observable(.success(result.token))
                } else {
                    observable(.error(error!))
                }
            }
            
            return Disposables.create()
        })
    }
    
    private func sendDeviceToken(userToken: String, deviceToken: String) -> Completable {
        return api.send(token: userToken, pushToken: deviceToken)
    }
    
}
