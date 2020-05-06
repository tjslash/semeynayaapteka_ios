//
//  DealDetailTopCardView.swift
//  TvoyaApteka
//
//  Created by oleg shkreba on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

class DealDetailTopCardView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.taOrange
        label.font = UIFont.Title.h2Bold
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.taBlack
        label.font = UIFont.Title.h4
        return label
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
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 11
        stackView.alignment = .leading
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 11, right: 16))
        }
    }
}
