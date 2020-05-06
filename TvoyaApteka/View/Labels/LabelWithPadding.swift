//
//  LabelWithPadding.swift
//  TvoyaApteka
//
//  Created by BuidMac on 17.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class LabelWithPadding: Label {
    
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(UIEdgeInsetsInsetRect(rect, contentInset))
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, contentInset))
    }
    
    override public var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += contentInset.top + contentInset.bottom
        size.width += contentInset.left + contentInset.right
        return size
    }
    
}
