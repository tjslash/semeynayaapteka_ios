//
//  FeedbackService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 02.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class FeedbackAPI: FeedbackAPIProtocol {
    
    private let adapter = NetworkAdapter<FeedbackRequest>()
    
    func sendFeedback(phone: String, text: String, name: String) -> Completable {
        let request = FeedbackRequest.sendFeedback(phone: phone, text: text, name: name)
        return adapter.send(request: request)
            .asCompletable()
    }
    
}
