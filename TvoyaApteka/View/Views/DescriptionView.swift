//
//  DescriptionView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class DescriptionView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h1Bold
        return label
    }()
    
    public let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.Title.h3
        return label
    }()
    
    public init(title: String, description: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        descriptionLabel.text = description
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
}
