//
//  Date+Format.swift
//  TvoyaApteka
//
//  Created by BuidMac on 01.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: String, localeIdentifier: String = "ru_RU") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        return dateFormatter.string(from: self)
    }
    
    func dayOfWeek(localeIdentifier: String = "ru_RU") -> String? {
        let dateFormatter = DateFormatter()
        let locale = Locale(identifier: localeIdentifier)
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized(with: locale)
    }
    
}
