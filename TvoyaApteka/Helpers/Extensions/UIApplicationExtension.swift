//
//  UIApplicationExtension.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.01.2019.
//  Copyright © 2019 Tematika. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var isFirstLaunch: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: "AppConfiguration_firstLaunchKey")
        }
        set(value) {
            UserDefaults.standard.set(!value, forKey: "AppConfiguration_firstLaunchKey")
        }
    }
    
}
