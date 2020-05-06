//
//  UITextView+HTML.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

extension UITextView {
    
    func setHTML(text: String, font: UIFont? = nil, color: UIColor? = nil) {
        let htmlToAttributedString = text.htmlToAttributedString
        htmlToAttributedString?.setFontFace(font: font ?? UIFont.smallText, color: color)
        self.attributedText = htmlToAttributedString
    }
    
}

extension String {
    
    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            return try NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
        } catch {
            return NSMutableAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension NSMutableAttributedString {
    func setFontFace(font: UIFont, color: UIColor? = nil) {
        beginEditing()
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, _) in
            if let fnt = value as? UIFont, let newFontDescriptor =
                fnt.fontDescriptor.withFamily(font.familyName).withSymbolicTraits(fnt.fontDescriptor.symbolicTraits) {
                let newFont = UIFont(descriptor: newFontDescriptor, size: font.pointSize)
                removeAttribute(.font, range: range)
                addAttribute(.font, value: newFont, range: range)
                if let color = color {
                    removeAttribute(.foregroundColor, range: range)
                    addAttribute(.foregroundColor, value: color, range: range)
                }
            }
        }
        endEditing()
    }
}
