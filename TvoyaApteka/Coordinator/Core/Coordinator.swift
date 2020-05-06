//
//  Coordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 28.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public protocol Coordinator: class {
    func start()
    func start(with option: DeepLinkOption?)
}
