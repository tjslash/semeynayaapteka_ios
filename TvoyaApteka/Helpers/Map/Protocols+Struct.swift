//
//  Protocols+Struct.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import YandexMapKit

protocol AnnotationBuilder {
    func create() -> [Annotation]
}

/// Object can showing on map
protocol MapObject {
    var latitude: String { get set }
    var longitude: String { get set }
}

struct Annotation {
    let point: YMKPoint
    let icon: UIImage?
    let userData: Any?
}
