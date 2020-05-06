//
//  Button.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class Button: UIButton {
  
    override public init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyStyle()
    }
    
    // Function for override
    func applyStyle() {}
    
    // Default styles for all app button
    override open var isHighlighted: Bool {
        didSet {
            if backgroundColor != UIColor.clear {
                backgroundColor = isHighlighted ? backgroundColor?.withAlphaComponent(0.7) : backgroundColor?.withAlphaComponent(1.0)
            }
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            backgroundColor = !isEnabled ? backgroundColor?.withAlphaComponent(0.4) : backgroundColor?.withAlphaComponent(1.0)
        }
    }
    
}

public extension UIButton {
    
    convenience public init(title text: String) {
        self.init(frame: .zero)
        self.setTitle(text, for: .normal)
    }

}
