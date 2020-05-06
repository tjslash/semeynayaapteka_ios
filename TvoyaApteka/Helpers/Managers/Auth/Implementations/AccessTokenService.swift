//
//  AccessTokenService.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.11.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class AccessTokenService {
    typealias Handler = (Token?, Error?) -> Void
    
    private let queue: DispatchQueue
    private var pendingHandlers = [Handler]()
    private let userService: UserAPIProtocol
    private let bag = DisposeBag()
    
    init(userService: UserAPIProtocol,
         queue: DispatchQueue = .init(label: "AccessToken")) {
        self.userService = userService
        self.queue = queue
    }
    
    func retrieve(token: Token, then handler: @escaping Handler) {
        queue.async { [weak self] in
            self?.performRetrieval(token: token, with: handler)
        }
    }
}

private extension AccessTokenService {
    
    func performRetrieval(token: Token, with handler: @escaping Handler) {
        if token.isValid {
            return handler(token, nil)
        }
        
        pendingHandlers.append(handler)
        
        guard pendingHandlers.count == 1 else {
            return
        }
        
        userService.updateToken(token: token.getFullTokenString())
            .subscribe(onSuccess: { [weak self] token in
                self?.queue.async {
                    self?.handle(token, nil)
                }
            }, onError: { [weak self] error in
                self?.queue.async {
                    self?.handle(nil, error)
                }
            })
            .disposed(by: bag)
    }
    
    func handle(_ token: Token?, _ error: Error?) {
        let handlers = pendingHandlers
        pendingHandlers = []
        handlers.forEach({ $0(token, error) })
    }
    
}
