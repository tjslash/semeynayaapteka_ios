//
//  SocialTitleView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable
public class SocialTitleView: UIView {
    
    private let leftLine = UIView()
    private let rightLine = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход через соцсети".uppercased()
        label.textAlignment = .center
        label.font = UIFont.normalText
        return label
    }()
    
    // MARK: - Public API
    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }
    
    var color: UIColor = .gray {
        didSet {
            titleLabel.textColor = color
            rightLine.backgroundColor = color
            leftLine.backgroundColor = color
        }
    }
    
    var lineHeight: CGFloat = 1 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupDefaultStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
        setupDefaultStyle()
    }
    
    // MARK: Private metods
    private func setupLayout() {
        addSubview(leftLine)
        addSubview(titleLabel)
        addSubview(rightLine)
        
        leftLine.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalToSuperview()
            make.right.equalTo(titleLabel.snp.left).offset(-16)
            make.height.equalTo(lineHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        rightLine.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(16)
            make.right.equalToSuperview()
            make.height.equalTo(lineHeight)
        }
    }
    
    private func setupDefaultStyle() {
        color = .gray
    }
    
}
