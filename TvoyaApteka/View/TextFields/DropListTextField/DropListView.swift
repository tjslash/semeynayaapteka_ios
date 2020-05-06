//
//  DropListView.swift
//  TvoyaAptekaInterface
//
//  Created by BuidMac on 11.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class DropListView: UIView {
    
    // MARK: Public API
    
    /// Set custom right view
    public var rightView: UIView = UIImageView() {
        willSet(oldView) {
            oldView.removeFromSuperview()
        }
        didSet {
            addSubview(rightView)
            setupRightViewLayout()
        }
    }
    
    /// Get textField
    public private(set) var textField: UITextField = RoundedTextField() {
        willSet(oldView) {
            oldView.removeFromSuperview()
        }
        didSet {
            insertSubview(textField, belowSubview: rightView)
            setupTextFieldLayout()
        }
    }
    
    private var rightViewWidthConstraint: Constraint?
    
    /// Set width for rightView
    internal var rightViewWidth: CGFloat = 50 {
        didSet {
            rightViewWidthConstraint?.update(offset: rightViewWidth)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        clipsToBounds = true
        textField.font = UIFont.Title.h4
        textField.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(textField)
        addSubview(rightView)
        
        setupTextFieldLayout()
        setupRightViewLayout()
    }
    
    private func setupTextFieldLayout() {
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupRightViewLayout() {
        rightView.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            rightViewWidthConstraint = make.width.equalTo(rightViewWidth).constraint
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height * 0.5
        textField.layer.cornerRadius = self.bounds.height * 0.5
    }
    
}

extension DropListView: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}
