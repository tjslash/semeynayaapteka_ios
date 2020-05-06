//
//  AnnotationBuilder.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import YandexMapKit

/// Creater store annotation
class StoreAnnotationBuilder<T: MapObject>: AnnotationBuilder {
    
    private let stores: [T]
    
    private let icon: UIImage = #imageLiteral(resourceName: "AnnotationIcon")
    
    init(stores: [T]) {
        self.stores = stores
    }
    
    func create() -> [Annotation] {
        var result: [Annotation] = []
        
        for store in stores {
            let point = getPoint(store: store)
            result.append(Annotation(point: point, icon: icon, userData: store))
        }
        
        return result
    }
    
    func getPoint(store: T) -> YMKPoint {
        return YMKPoint(latitude: Double(store.latitude)!, longitude: Double(store.longitude)!)
    }
    
}
