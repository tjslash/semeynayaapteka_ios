//
//  Card.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 03/04/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class CardView: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupBackground()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBackground()
    }
    
    private func setupBackground() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 3
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    public func setShadowColor(_ color: CGColor) {
        self.layer.shadowColor = color
    }
    
    public func setShadowRadius(_ radius: CGFloat) {
        self.layer.shadowRadius = radius
    }
    
    public func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    public func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
}
