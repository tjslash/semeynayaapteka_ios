//
//  EmptyListView.swift
//  TvoyaAptekaInterface
//
//  Created by BuidMac on 20.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class EmptyListView: UIView {
    
    private let iconView = UIImageView(image: #imageLiteral(resourceName: "empty_list_icon"))
    
    private let titleLabel: UILabel = {
        let label = UILabel(text: "Список пуст")
        label.font = UIFont.Title.h2Bold
        label.textAlignment = .center
        return label
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let wrapperView = UIView()
        
        addSubview(wrapperView)
        wrapperView.addSubview(iconView)
        wrapperView.addSubview(titleLabel)
        
        wrapperView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(77)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(43)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}
