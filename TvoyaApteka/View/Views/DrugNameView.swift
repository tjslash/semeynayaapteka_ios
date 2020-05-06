//
//  DrugNameView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class DrugNameView: UIView {
    
    let drugImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.taAlmostWhite
        imageView.layer.borderColor = UIColor.taLightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 2
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let drugNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .taBlack
        label.font = UIFont.Title.h3Bold
        return label
    }()
    
    let secondaryDrugNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .taBlack
        label.font = UIFont.Title.h4
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setHighlight(_ highlight: Bool) {
        if highlight {
            drugNameLabel.textColor = .taPrimary
        } else {
            drugNameLabel.textColor = .taBlack
        }
    }
    
    private func setupLayout() {
        let nameStackView = UIStackView(arrangedSubviews: [drugNameLabel, secondaryDrugNameLabel])
        nameStackView.axis = .vertical
        nameStackView.spacing = 5
        nameStackView.alignment = .leading
        
        drugImageView.snp.makeConstraints { make in
            make.height.width.equalTo(56)
        }
        
        let stackView = UIStackView(arrangedSubviews: [drugImageView, nameStackView])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
