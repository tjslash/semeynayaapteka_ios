//
//  StoreFreeday.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import SwiftyJSON

struct StoreFreeday: Codable {
    let id: Int
    let status: String
    let startDatetime: Date?
    let endDatetime: Date?
}

extension StoreFreeday: RemoteEntity {
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let status = json["freeday_status"].string
            else { return nil }
        
        self.id = id
        self.status = status
        self.startDatetime = json["start_datetime"]["date"].string?.toDate(withFormat: .jsonDateWithMs)
        self.endDatetime = json["end_datetime"]["date"].string?.toDate(withFormat: .jsonDateWithMs)
    }
    
    func isInclude(date: Date) -> Bool {
        if startDatetime == nil, let endDate = endDatetime {
            return date <= endDate
        }
        
        if endDatetime == nil, let startDate = startDatetime {
            return date >= startDate
        }
        
        if let startDate = startDatetime, let endDate = endDatetime {
            return !date.isBetween(startDate, and: endDate)
        }
        
        fatalError("Error freeday logic")
    }
    
}

extension Date {
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
}
