//
//  ErrorPresenter.swift
//  TvoyaApteka
//
//  Created by BuidMac on 19.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftMessages

class ErrorPresenter {
    
    static public func showError(text: String) {
        let viewError = createMessageView(text: text)
        SwiftMessages.show(view: viewError)
    }
    
    static private func createMessageView(text: String) -> MessageView {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.warning)
        view.configureTheme(backgroundColor: UIColor(rgb: 0xFFEB99), foregroundColor: UIColor.black)
        view.button?.isHidden = true
        view.configureContent(title: "", body: text)
        return view
    }
    
}
