//
//  ChatCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 28.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import Chat

class ChatCoordinator: BaseCoordinator {
    
    override func start() {
        showChatPage()
    }
    
    private func showChatPage() {
        let page = Chat.ChatPage()
        router.push(page, animated: false, completion: nil)
    }
    
}
