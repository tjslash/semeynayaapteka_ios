//
//  Data+DebugLog.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

extension Data {
    
    /// Функция переводит данные в строку.
    /// Эта операция надежна только в случае каста UTF8!
    /// В случае провала - просто выведет в консоль сообщение!
    /// Она существует исключительно для удобства, чтобы не возиться с опционалами
    /// - Parameter encoding: Какое кодирование использовать при касте (по умолчанию UTF8)
    func toString(encoding: String.Encoding = .utf8) -> String {
        guard let ret = String(data: self, encoding: encoding) else {
            print("Data to String conversion fail. On data:\(self)")
            return ""
        }
        return ret
    }
    
    /// Быстрый отладочный вывод
    func debugOutput(prefix: String = "dataDebug") {
        print(prefix + ":" + self.toString())
    }
    
}
