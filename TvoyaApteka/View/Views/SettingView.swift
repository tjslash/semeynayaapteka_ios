//
//  SettingView.swift
//  TvoyaAptekaInterface
//
//  Created by BuidMac on 10.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class SettingView: CardView {
    
    // MARK: Public API
    
    /// Set text
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: Private API
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .taPrimary
        label.font = UIFont.Title.h3
        return label
    }()
    
    let controlSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .taPrimary
        return sw
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(controlSwitch)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(controlSwitch.snp.left).offset(-10)
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        controlSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 343, height: 56)
    }
    
}
