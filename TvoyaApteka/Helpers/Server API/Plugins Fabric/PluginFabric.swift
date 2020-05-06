//
//  PluginFabric.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import Moya
import UIKit

class PluginFabric {
    
    func makePlugins() -> [PluginType] {
        return [
            makeNetworkActivityPlugin(),
            makeLogerPlugin()
        ]
    }
    
    func makeNetworkActivityPlugin() -> PluginType {
        return NetworkActivityPlugin { changeType, _ in
            DispatchQueue.main.async {
                switch changeType {
                case .began:
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                case .ended:
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    func makeLogerPlugin() -> PluginType {
        return NetworkLogger()
    }
    
}
