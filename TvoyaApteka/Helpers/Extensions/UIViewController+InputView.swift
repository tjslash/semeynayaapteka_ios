//
//  UIViewController+InputView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 16.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addDoneToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(donePressedDoneToolBar))
        doneButton.tintColor = UIColor.taPrimary
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    @objc
    private func donePressedDoneToolBar() {
        view.endEditing(true)
    }
    
}
