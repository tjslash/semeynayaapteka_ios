//
//  NewsAnnotationCell.swift
//  TvoyaApteka
//
//  Created by BuidMac on 12.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class ArticlesAnnotationCell: TableViewCardCell {
    
    // MARK: Public API
    /// Set title text
    public var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    /// Set description text
    public var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    /// Set date text
    public var dateText: String? {
        didSet {
            dateLabel.text = dateText
        }
    }
    
    // MARK: Private
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.Title.h2Bold
        lb.textColor = .taBlack
        lb.numberOfLines = 2
        return lb
    }()
    
    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.Title.h4
        lb.textColor = .taGray
        lb.numberOfLines = 1
        return lb
    }()
    
    private let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.Title.h4
        lb.textColor = .taBlack
        lb.numberOfLines = 2
        return lb
    }()
    
    private let customAccessoryView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "RightArrow"))
        imageView.contentMode = .center
        imageView.tintColor = .taGray
        return imageView
    }()
  
    override public func applyStyle() {
        super.applyStyle()
        titleLabel.textColor = .taBlack
        customAccessoryView.tintColor = .taGray
    }
    
    override public func applyHighlightedStyle() {
        super.applyHighlightedStyle()
        titleLabel.textColor = .taPrimary
        customAccessoryView.tintColor = .taPrimary
    }
    
    override public func setupLayout() {
        super.setupLayout()
        
        let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel, descriptionLabel])
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .leading
        labelsStackView.spacing = 13
        
        let mainStackView = UIStackView(arrangedSubviews: [labelsStackView, customAccessoryView])
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.spacing = 5
        
        bgView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
}
