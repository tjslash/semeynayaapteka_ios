//
//  FeedBackRepository.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class FeedBackRepository: FeedBackRepositoryType {
    
    func sendFeedback(phone: String, text: String, name: String) -> Completable {
        return ServerAPI.feedback.sendFeedback(phone: phone, text: text, name: name)
    }
    
}
