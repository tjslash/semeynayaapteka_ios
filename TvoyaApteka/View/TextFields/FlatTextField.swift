//
//  FlatTextField.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class FlatTextField: UITextField {
    
    override public var tintColor: UIColor! {
        didSet {
            updateViewState()
        }
    }

    /// Set text for error
    public var errorMessage: String? = nil {
        didSet {
            if let message = errorMessage, message.count > 0 {
                lineColor = errorColor
            } else {
                lineColor = .taLightGray
            }
            
            errorLabel.text = errorMessage
            updateViewState()
        }
    }
    
    /// Set color for error text
    public var errorColor: UIColor = .taRed {
        didSet {
            errorLabel.textColor = errorColor
        }
    }
    
    /// Set color for line between text and error
    public var lineColor: UIColor = .taLightGray
    
    // MARK: Private API
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h4
        label.textColor = UIColor.taRed
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        defaultSetup()
    }
    
    convenience public init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        defaultSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultSetup()
    }
  
    private func updateViewState() {
        setNeedsDisplay()
        layoutSubviews()
    }
  
    private func defaultSetup() {
        self.borderStyle = .none
        self.addSubview(errorLabel)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutErrorLabel()
    }
    
    private func layoutErrorLabel() {
        errorLabel.frame.size.height = errorLabel.sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude)).height
        errorLabel.frame.origin.x = bounds.origin.x
        errorLabel.frame.origin.y = bounds.height
        errorLabel.frame.size.width = bounds.width
    }
    
    override public func draw(_ rect: CGRect) {
        let startingPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 2.0
        lineColor.setStroke()
        path.stroke()
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 50)
    }
    
}
