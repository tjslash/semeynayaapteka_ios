//
//  PromocodeInputView.swift
//  TvoyaAptekaInterface
//
//  Created by BuidMac on 11.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class PromocodeInputView: DropListView {
    
    public var didTapRightView: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let actionButton = UIButton()
        actionButton.setImage(#imageLiteral(resourceName: "RightArrow"), for: .normal)
        actionButton.imageView?.tintColor = UIColor.taAlmostWhite
        actionButton.addTarget(self, action: #selector(didTapRightViewHandler), for: .touchUpInside)
        self.rightView = actionButton
        self.rightView.backgroundColor = .taPrimary
        self.rightView.contentMode = .center
        self.textField.textColor = .taGray
        self.textField.tintColor = .black
        self.rightViewWidth = 72
    }
    
    @objc private func didTapRightViewHandler() {
        didTapRightView?()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
