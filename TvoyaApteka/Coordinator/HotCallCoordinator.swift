//
//  HotCallCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 28.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

class HotCallCoordinator: BaseCoordinator {
    
    override func start() {
        showHotCallPage()
    }
    
    private func showHotCallPage() {
        let page = createHotCallPage()
        router.push(page, animated: false, completion: nil)
    }
    
    private func createHotCallPage() -> UIViewController {
        let configurator = InfoWithActionPage.Configurator(image: #imageLiteral(resourceName: "Headphones"),
                                                           title: "Есть вопросы?",
                                                           description: "Позвони по телефону горячей линии в наш \nконтактный центр",
                                                           buttonTitle: "Позвонить".uppercased(),
                                                           action: call)
        let page = InfoWithActionPage(configurator: configurator)
        page.title = "Справка"
        return page
    }
    
    private func call() {
        if #available(iOS 10, *) {
            UIApplication.shared.open(Const.Url.support)
        } else {
            UIApplication.shared.openURL(Const.Url.support)
        }
    }
    
}
