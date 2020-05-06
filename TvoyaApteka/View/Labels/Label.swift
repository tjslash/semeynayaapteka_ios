//
//  Label.swift
//  TvoyaApteka
//
//  Created by BuidMac on 03.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class Label: UILabel {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyStyle()
    }
    
    // Function for override
    func applyStyle() {}
    
}

public extension UILabel {
    
    convenience public init(text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
}
