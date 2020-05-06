//
//  RoundedTextField.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 06/04/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class RoundedTextField: UITextField {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        self.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.borderStyle = .none
        self.layer.masksToBounds = true
        setupBorders()
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 12, dy: 0)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 12, dy: 0)
    }
    
    private func setupBorders() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.taLightGray.cgColor
        self.layer.cornerRadius = self.frame.height * 0.5
    }
    
}
