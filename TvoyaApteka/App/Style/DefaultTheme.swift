//
//  DefaultTheme.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

class DefaultTheme {
    
    static func apply() {
        setupStatusBar()
        setupNavBarStyle()
        setupTabBarStyle()
    }
    
    static private func setupStatusBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        return
    }
    
    static private func setupNavBarStyle() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = UIColor.taPrimary
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = UIColor.taAlmostWhite
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    static func setupTabBarStyle() {
        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.taAlmostWhite
        tabBar.tintColor = UIColor.taPrimary
    }
    
}
