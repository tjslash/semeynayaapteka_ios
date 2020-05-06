//
//  UIViewController+PhoneMask.swift
//  TvoyaApteka
//
//  Created by BuidMac on 17.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

 /// Code of PhoneFormatter class taken from https://github.com/Serheo/PhoneNumberFormatter
public extension UITextField {
    
    public func applyPhoneMask(shouldChangeCharactersIn range: NSRange, replacementString string: String) {
        let phoneFormat = PhoneFormat(defaultPhoneFormat: Const.Mask.phone)
        let config = ConfigurationRepo(defaultFormat: phoneFormat)
        let phoneFormatter = PhoneFormatter(config: config)
        
        let resultText = self.text ?? ""
        let caretPosition = phoneFormatter.pushCaretPosition(text: resultText, range: range)
        
        let rangeExpressionStart = resultText.index(resultText.startIndex, offsetBy: range.location)
        let rangeExpressionEnd = resultText.index(resultText.startIndex, offsetBy: range.location + range.length)
        let newString = resultText.replacingCharacters(in: rangeExpressionStart..<rangeExpressionEnd, with: string)
        
        let result = phoneFormatter.formatText(text: newString)
        self.text = result.text
        
        if let positionRange = phoneFormatter.popCaretPosition(textField: self,
                                                               range: range,
                                                               caretPosition: caretPosition) {
            self.selectedTextRange = self.textRange(from: positionRange.startPosition,
                                                              to: positionRange.endPosition)
        }
        
        self.sendActions(for: .valueChanged)
    }
    
    public func applyBonusCardMask(shouldChangeCharactersIn range: NSRange, replacementString string: String) {
        let phoneFormat = PhoneFormat(defaultPhoneFormat: Const.Mask.bonusCard)
        let config = ConfigurationRepo(defaultFormat: phoneFormat)
        let phoneFormatter = PhoneFormatter(config: config)
        let resultText = self.text ?? ""
        let caretPosition = phoneFormatter.pushCaretPosition(text: resultText, range: range)
        
        let rangeExpressionStart = resultText.index(resultText.startIndex, offsetBy: range.location)
        let rangeExpressionEnd = resultText.index(resultText.startIndex, offsetBy: range.location + range.length)
        let newString = resultText.replacingCharacters(in: rangeExpressionStart..<rangeExpressionEnd, with: string)
        
        let result = phoneFormatter.formatText(text: newString)
        self.text = result.text
        
        if let positionRange = phoneFormatter.popCaretPosition(textField: self,
                                                               range: range,
                                                               caretPosition: caretPosition) {
            self.selectedTextRange = self.textRange(from: positionRange.startPosition,
                                                              to: positionRange.endPosition)
        }
        
        self.sendActions(for: .valueChanged)
    }
}

extension String {
    
    func applyMask(format: String) -> String {
        let phoneFormat = PhoneFormat(defaultPhoneFormat: format)
        let config = ConfigurationRepo(defaultFormat: phoneFormat)
        let phoneFormatter = PhoneFormatter(config: config)
        return phoneFormatter.formatText(text: self).text
    }
    
}
