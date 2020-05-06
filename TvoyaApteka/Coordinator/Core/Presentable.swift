//
//  Presentable.swift
//  TvoyaApteka
//
//  Created by BuidMac on 28.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public protocol Presentable {
    func toPresentable() -> UIViewController
}

extension UIViewController: Presentable {
    
    public func toPresentable() -> UIViewController {
        return self
    }
    
}
