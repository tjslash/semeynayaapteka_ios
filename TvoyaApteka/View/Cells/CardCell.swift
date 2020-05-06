//
//  CardCell.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class TableViewCardCell: UITableViewCell {
    
    let bgView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupLayout()
        applyStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupLayout() {
        contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-7)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            applyHighlightedStyle()
        } else {
            applyStyle()
        }
    }
    
    open func applyStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 3
        bgView.layer.shadowRadius = 3
        bgView.layer.shadowOpacity = 0.2
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    open func applyHighlightedStyle() {
        bgView.layer.shadowRadius = 6
        bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
}

public class CollectionViewCardCell: UICollectionViewCell {
    
    let bgView = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        applyStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupLayout() {
        contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-7)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    open func applyStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 3
        bgView.layer.shadowRadius = 3
        bgView.layer.shadowOpacity = 0.2
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    open func applyHighlightedStyle() {
        bgView.layer.shadowRadius = 6
        bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
}
