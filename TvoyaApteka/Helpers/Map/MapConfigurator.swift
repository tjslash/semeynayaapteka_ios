//
//  MapConfigurator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import YandexMapKit
import CoreLocation

class MapConfigurator {
    
    /// Zoom single object, by default is 17
    public var zoom: Float = 17
    
    /// Listener for event wnen user tap pm marker
    public var tapListener: YMKMapObjectTapListener?
    
    /// Builder
    public let builder: AnnotationBuilder
    
    private let map: YMKMap
    private var annotations: [Annotation] = []
    private var customPosition: CLLocationCoordinate2D?
    
    init(map: YMKMap, builder: AnnotationBuilder, customPosition: CLLocationCoordinate2D? = nil) {
        self.map = map
        self.builder = builder
        self.customPosition = customPosition
    }
    
    /// Update annotations marks and move camera
    public func updateMap() {
        annotations = builder.create()
        updateAnnotation()
        moveCamera()
    }
    
    private func updateAnnotation() {
        map.mapObjects?.clear()
        let markStore = map.mapObjects?.add()
        
        for annotation in annotations {
            let placemark = markStore?.addPlacemark(with: annotation.point, image: annotation.icon)
            placemark?.userData = annotation.userData
            placemark?.addTapListener(with: tapListener)
        }
        
    }
    
    private func moveCamera() {
        if let customPosition = customPosition {
            let point = YMKPoint(latitude: customPosition.latitude, longitude: customPosition.longitude)
            let position = YMKCameraPosition(target: point, zoom: zoom, azimuth: 0, tilt: 0)
            map.move(with: position)
            return
        }
        
        if annotations.count > 1, let point = annotations.getCenterPoint() {
            map.move(with: YMKCameraPosition(target: point, zoom: 12, azimuth: 0, tilt: 0))
            return
        }
        
        if let annotation = annotations.first {
            map.move(with: YMKCameraPosition(target: annotation.point, zoom: zoom, azimuth: 0, tilt: 0))
        }
    }
    
}

fileprivate extension Array where Element == Annotation {
    
    func getRegion() -> YMKBoundingBox? {
        guard self.count > 1 else { return nil }
        
        let longArray = self.map { $0.point.longitude }
        let latArray = self.map { $0.point.latitude }
        
        let minLong = longArray.min()!
        let maxLong = longArray.max()!
        
        let minLat =  latArray.min()!
        let maxLat =  latArray.max()!
        
        let southWest = YMKPoint(latitude: minLat, longitude: minLong)
        let northEast = YMKPoint(latitude: maxLat, longitude: maxLong)
        
        return YMKBoundingBox(southWest: southWest, northEast: northEast)
    }
    
    func getCenterPoint() -> YMKPoint? {
        guard self.count >= 1 else { return nil }
        
        let longArray = self.map { $0.point.longitude }
        let latArray = self.map { $0.point.latitude }
        
        let minLong = longArray.min()!
        let maxLong = longArray.max()!
        
        let minLat =  latArray.min()!
        let maxLat =  latArray.max()!
        
        return YMKPoint(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2)
    }
    
}
