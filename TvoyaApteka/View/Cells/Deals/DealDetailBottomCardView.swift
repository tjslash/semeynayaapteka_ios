//
//  DealDetailBottomCardView.swift
//  TvoyaApteka
//
//  Created by oleg shkreba on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

class DealDetailBottomCardView: UIView {
    
    let imageCalendar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "calendar")
        imageView.tintColor = UIColor.taPrimary
        return imageView
    }()
    
    let daysUntilTheEndLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.taBlack
        label.font = UIFont.Title.h4
        return label
    }()
    
    let textShares: UILabel = {
        let text = UILabel()
        text.textColor = UIColor.taBlack
        text.numberOfLines = 0
        text.font = UIFont.Title.h4
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let daysStackView = UIStackView(arrangedSubviews: [imageCalendar, daysUntilTheEndLabel])
        daysStackView.axis = .horizontal
        daysStackView.alignment = .leading
        daysStackView.spacing = 14
        
        imageCalendar.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.equalTo(17)
        }
        
        let stackView = UIStackView(arrangedSubviews: [daysStackView, textShares])
        stackView.axis = .vertical
        stackView.spacing = 11
        stackView.alignment = .leading
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        }
    }
}
