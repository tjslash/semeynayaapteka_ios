//
//  StoreAnnotationCell.swift
//  TvoyaApteka
//
//  Created by BuidMac on 11.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class DrugStoreCell: TableViewCardCell {

    var viewModel: DrugStoreCellModel! {
        didSet {
            binding()
        }
    }
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .taLightGray
        return view
    }()
    
    public let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h4Bold
        label.textColor = .taBlack
        return label
    }()
    
    public let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h4
        label.textColor = .taBlack
        return label
    }()
    
    public let scheduleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h4
        label.textColor = .taGray
        return label
    }()
    
    public let revisionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h5
        label.textColor = .taRed
        return label
    }()
    
    public let revisionImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "locked-padlock"))
        imageView.contentMode = .center
        imageView.tintColor = .taRed
        imageView.backgroundColor = .clear
        return imageView
    }()

    private struct SpacingRules {
        static let top = 12
        static let left = 16
        static let right = -16
        static let bottom = -12
        static let lineHeight = 1
        static let verticalOffset = 14
        static let descriptionVerticalOffset = 5
    }
    
    override public func setupLayout() {
        super.setupLayout()
        let revisionStackView = UIStackView(arrangedSubviews: [revisionLabel, UIView(), revisionImage])
        revisionStackView.axis = .horizontal
        revisionStackView.alignment = .center
        
        let storeDescriptionStackView = UIStackView(arrangedSubviews: [addressLabel, scheduleLabel, revisionStackView])
        storeDescriptionStackView.axis = .vertical
        storeDescriptionStackView.spacing = CGFloat(SpacingRules.descriptionVerticalOffset)
        storeDescriptionStackView.alignment = .fill
    
        bgView.addSubview(storeNameLabel)
        bgView.addSubview(lineView)
        bgView.addSubview(storeDescriptionStackView)
        
        storeNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SpacingRules.left)
            make.right.equalToSuperview().offset(SpacingRules.right)
            make.top.equalToSuperview().offset(SpacingRules.top)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(SpacingRules.lineHeight)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(storeNameLabel.snp.bottom).offset(SpacingRules.verticalOffset)
        }
        
        storeDescriptionStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SpacingRules.left)
            make.right.equalToSuperview().offset(SpacingRules.right)
            make.top.equalTo(lineView.snp.bottom).offset(SpacingRules.verticalOffset)
            make.bottom.equalToSuperview().offset(SpacingRules.bottom)
        }
    }
    
    private func binding() {
        storeNameLabel.text = viewModel.storeNameText
        addressLabel.text = viewModel.addressText
        scheduleLabel.text = viewModel.scheduleText
        revisionLabel.text = viewModel.revisionText
        revisionImage.isHidden = viewModel.revisionImageIsHidden
    }
    
}
