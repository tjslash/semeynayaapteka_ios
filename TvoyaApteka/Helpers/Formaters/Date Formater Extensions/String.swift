//  String.swift

import Foundation

enum DateFormat: String {
    case jsonDate = "yyyy-MM-dd HH:mm:ss" //"2018-06-29 13:01:20"
    case jsonDateWithMs = "yyyy-MM-dd HH:mm:ss.SSSSSS" //"2018-03-30 15:25:08.000000"
    case dateText = "dd MMM yyyy" // 10 октября 2017
    case dateShortDottedText = "dd.MM.yyyy"
}

extension String {
    
    /// Кастует строку в данные, используя по умолчанию UTF8
    /// Каст может провалиться и появится собщение в отладке!
    /// Функция падать не будет и вернет пустой объект.
    /// Исключительно для исключения возни с опционалами!
    /// - parameter encoding: Кодировка для каста
    func toData(encoding: String.Encoding = .utf8) -> Data {
        guard let ret = self.data(using: encoding) else {
            print("String to Data conversion fail. On string:\(self)")
            return Data()
        }
        return ret
    }
    
    /// Кастует в дату, принимая на вход формат, описанный в DateFormat
    /// - parameter withFormat: enum: String который используется для каста
    func toDate(withFormat format: DateFormat) -> Date? {
        return toDate(withFormat: format.rawValue)
    }
    
    /// Кастует в дату, принимая на вход строку с форматом
    /// - parameter withFormat: строковый формат каста
    func toDate(withFormat format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self) ?? nil
    }
    
    /// Быстрый отладочный вывод
    func debugOutput(prefix: String = "debugString") {
        print(prefix + ":" + self)
    }
}
