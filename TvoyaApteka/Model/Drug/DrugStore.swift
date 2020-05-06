//
//  Store.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

struct DrugStore: Codable, RemoteImage {
    let id: Int
    let cityId: Int
    let title: String
    let address: String
    var latitude: String
    var longitude: String
    let images: [String]
    let freeday: StoreFreeday?
    private let worktime: String?
    private let is24h: Bool
}

extension DrugStore: RemoteEntity {
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let cityId = json["city_id"].int,
            let title = json["title"].string,
            let address = json["address"].string,
            let latitude = json["latitude"].string,
            let longitude = json["longitude"].string,
            let worktime = json["worktime"].string,
            let is24h = json["is_24h"].bool
            else { return nil }
        
        self.id = id
        self.cityId = cityId
        self.title = title
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.worktime = worktime
        self.is24h = is24h
        self.freeday = StoreFreeday(json: json["freeday"])
        self.images = json["images"].arrayValue.compactMap { $0.string }
    }
    
}

extension DrugStore {
    
    func getScheduleString() -> String {
        if is24h {
            return "Круглосуточно"
        } else {
            return worktime ?? ""
        }
    }
    
    func getFreedayString() -> String? {
        guard let freeday = freeday else { return nil }
        var ret = freeday.status
        
        let fromDate = freeday.startDatetime?.toString(withFormat: .dateText)
        let toDate = freeday.endDatetime?.toString(withFormat: .dateText)
        
        if fromDate == toDate {
            ret += (" \(fromDate ?? "")")
        } else {
            if let date = fromDate {
                ret += " с " + date
            }
            
            if let date = toDate {
                ret += " до " + date
            }
        }
    
        return ret
    }
    
    func isWorkingToday() -> Bool {
        guard let freeday = freeday else {
            return true
        }
        
        let currentDate = Date()
        return freeday.isInclude(date: currentDate)
    }
    
}

// MARK: - MapObject
extension DrugStore: MapObject {
    
    func distanceTo(userPosition: CLLocation) -> Double? {
        guard let latitude = Double(latitude) else { return nil }
        guard let longitude = Double(longitude) else { return nil }
        let storePosition = CLLocation(latitude: latitude, longitude: longitude)
        return userPosition.distance(from: storePosition)
    }
    
}
