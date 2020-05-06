//
//  NetworkLogger.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import Moya
import Result
import Log

/// Logs network activity (outgoing requests and incoming responses).
class NetworkLogger: PluginType {
    
    typealias Comparison = (TargetType) -> Bool

    let whitelist: Comparison
    let blacklist: Comparison

    private let logger = Logger(formatter: .minimal)
    
    init(whitelist: @escaping Comparison = { _ -> Bool in return true }, blacklist: @escaping Comparison = { _ -> Bool in  return true }) {
        self.whitelist = whitelist
        self.blacklist = blacklist
    }
    
    func willSendRequest(_ request: RequestType, target: TargetType) {
        // If the target is in the blacklist, don't log it.
        guard blacklist(target) == false else { return }
        logger.warning("Sending request: \(request.request?.url?.absoluteString ?? String())")
    }
    
    func didReceiveResponse(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        // If the target is in the blacklist, don't log it.
        guard blacklist(target) == false else { return }
        
        switch result {
        case .success(let response):
            if 200..<400 ~= (response.statusCode ) && whitelist(target) == false {
                // If the status code is OK, and if it's not in our whitelist, then don't worry about logging its response body.
                logger.warning("Received response(\(response.statusCode )) from \(response.response?.url?.absoluteString ?? String()).")
            }
        case .failure(let error):
            // Otherwise, log everything.
            logger.warning("Received networking error: \(error)")
        }
    }
}
