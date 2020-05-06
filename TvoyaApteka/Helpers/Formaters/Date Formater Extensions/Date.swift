//  Date.swift

import Foundation

extension Date {
    
    /// Кастует дату в строку, используя формат даты, указанный в enum DateFormat
    /// - parameter withFormat: enum: String который используется для каста
    func toString(withFormat format: DateFormat) -> String {
        return toString(withFormat: format.rawValue)
    }
    
    /// Кастует дату в строку, используя строковый формат параметра
    /// - parameter withFormat: строковый формат каста
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }
    
    /// Быстрый отладочный вывод
    func debugOutput(prefix: String = "timeDebug") {
        print(prefix + ":" + self.toString(withFormat: .jsonDate))
    }
}
