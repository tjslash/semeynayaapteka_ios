//
//  MenuCells.swift
//  TvoyaApteka
//
//  Created by BuidMac on 17.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

class MenuCell: UITableViewCell {
    
    let itemIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupLayout() {
        contentView.addSubview(itemIcon)
        contentView.addSubview(titleLabel)
        
        itemIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(35)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(itemIcon.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
}

class MenuCellWithDescription: MenuCell {
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    override func setupLayout() {
        super.setupLayout()
        contentView.addSubview(descriptionLabel)
        
        titleLabel.snp.removeConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(descriptionLabel.snp.width)
            make.left.equalTo(itemIcon.snp.right).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(titleLabel.snp.width)
            make.right.equalToSuperview().offset(-20)
            make.left.equalTo(titleLabel.snp.right).offset(20)
        }
        
        descriptionLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        descriptionLabel.setContentCompressionResistancePriority(.init(249), for: .horizontal)
    }
    
}
