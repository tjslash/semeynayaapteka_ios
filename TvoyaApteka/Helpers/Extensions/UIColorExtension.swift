//  UIColor.swift

import UIKit

extension UIColor {
    
    /// Удобный! Конструктор UIColor из RGB
    /// - parameter red: Красный [0, 255]
    /// - parameter green: Зеленый [0, 255]
    /// - parameter blue: Синий [0, 255]
    /// - parameter alpha: Альфа канал [0.0, 1.0], где 0.0 - прозрачный
    convenience init(_ red: UInt8, _ green: UInt8, _ blue: UInt8, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(Int(red))/255,
            green: CGFloat(Int(green))/255,
            blue: CGFloat(Int(blue))/255,
            alpha: alpha)
    }
    
    /// Конструктор создает UIColor из строки формата "#FFFFFF"
    /// - parameter fromHex: поддерживаемые форматы: "#F0F" (rgb), "#FF00FF" (rgb), "#FF00FF00" (rgba)
    convenience init?(fromHex hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue: UInt8
        let alpha: CGFloat
        
        if chars.count == 3 {
            chars = chars.flatMap { [$0, $0] }
        }
        
        if chars.count == 6 {
            chars += ["F", "F"]
        }
        
        if chars.count == 8 {
            red   = UInt8(strtoul(String(chars[0...1]), nil, 16))
            green = UInt8(strtoul(String(chars[2...3]), nil, 16))
            blue  = UInt8(strtoul(String(chars[4...5]), nil, 16))
            alpha = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
            
            self.init(red, green, blue, alpha: alpha)
        } else {
            return nil
        }
    }
    
    /// Конструктор создает цвет из строки "255, 0, 0".
    /// Параметры в строке соответственно r g b
    /// - parameter fromStringWithRgbInt: строка в формате "[0, 255], [0, 255], [0, 255]".
    ///  Например " 128, 128, 128" (серый)
    convenience init?(fromStringWithRgbInt numString: String) {
        let numString = numString.filter { "0123456789,".contains($0) }
        let intArr = numString.components(separatedBy: ",").compactMap { UInt8($0) }
        
        switch intArr.count {
        case 3: self.init(intArr[0], intArr[1], intArr[2])
        default: return nil
        }
    }
    
    /// Перебирает конструкторы со строкой
    /// и если удается - инициализирует что нибудь
    convenience init?(fromSomeString named: String) {
        let named = named.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if named.hasPrefix("#") {
            self.init(fromHex: named)
        } else {
            self.init(fromStringWithRgbInt: named)
        }
    }
}
