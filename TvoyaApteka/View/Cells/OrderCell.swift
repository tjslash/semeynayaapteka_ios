//
//  OrderCell.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class OrderCell: TableViewCardCell {
    
    var viewModel: OrderCellModel! {
        didSet {
          binding()
        }
    }
    
    public let stateLabel = StatusLabel()
    
    public let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h3
        label.textColor = .taBlack
        return label
    }()
    
    public let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h5
        label.textColor = .taGray
        return label
    }()
    
    public let costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h3Bold
        label.textColor = .taBlack
        label.textAlignment = .right
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "order_icon"))
        imageView.tintColor = UIColor.taPrimary
        return imageView
    }()
    
    override public func setupLayout() {
        super.setupLayout()
        
        bgView.addSubview(iconView)
        bgView.addSubview(stateLabel)
        bgView.addSubview(orderNumberLabel)
        bgView.addSubview(addressLabel)
        bgView.addSubview(costLabel)
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(16)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(iconView.snp.right).offset(16)
            make.width.equalTo(84)
            make.height.equalTo(20)
        }
        
        orderNumberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconView.snp.right).offset(16)
            make.right.equalTo(costLabel.snp.left).offset(-10)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        costLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func binding() {
        addressLabel.text = viewModel.addressText
        costLabel.text = viewModel.costText
        stateLabel.text = viewModel.stateText
        orderNumberLabel.text = viewModel.orderNumberText
    }
    
}
