//
//  DrugDescriptionView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class DrugDescriptionView: UIView {
    
    public var recipeStatus: RecipeStatus = .none {
        didSet {
            switch recipeStatus {
            case .recipe:
                recipeImageView.tintColor = .taRed
                recipeImageView.backgroundColor = .taAlmostWhite
                recipeImageView.isHidden = false
            case .recipe2:
                recipeImageView.tintColor = .taPrimary
                recipeImageView.backgroundColor = .taAlmostWhite
                recipeImageView.isHidden = false
            default:
                recipeImageView.isHidden = true
                recipeImageView.backgroundColor = .clear
            }
        }
    }
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h2Bold
        label.numberOfLines = 0
        return label
    }()
    
    public let manufacturerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h4
        label.numberOfLines = 1
        return label
    }()
    
    public let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "favorite-selected"), for: .selected)
        button.imageView?.contentMode = .center
        button.imageView?.tintColor = UIColor.taRed
        return button
    }()
    
    public let countlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h4
        label.numberOfLines = 0
        return label
    }()
    
    public let drugImageView = UIImageView()
    public let storeTextField = AddressDropListView()
    public let price = CostWithDiscountView(layout: .vertical, font: .large)
    
    public let buyView: BuyActionView = {
        let view = BuyActionView(status: .notBought)
        view.buyButton.layer.shadowColor = UIColor.taPrimary.cgColor
        view.buyButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        view.buyButton.layer.shadowRadius = 12.0
        view.buyButton.layer.shadowOpacity = 0.4
        return view
    }()
    
    private let recipeImageView = UIImageView(image: #imageLiteral(resourceName: "strictly-recipe"))
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupWrapView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(manufacturerLabel)
        addSubview(favoriteButton)
        addSubview(drugImageView)
        addSubview(countlabel)
        addSubview(storeTextField)
        addSubview(recipeImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.left.equalToSuperview()
        }
        
        manufacturerLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.right.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(22)
            make.left.equalTo(titleLabel.snp.right).offset(14)
        }
        
        drugImageView.snp.makeConstraints { make in
            make.top.equalTo(manufacturerLabel.snp.bottom).offset(17)
            make.right.left.equalToSuperview()
            make.height.equalTo(drugImageView.snp.width).multipliedBy(9.0 / 16.0)
        }
        
        countlabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.equalTo(drugImageView.snp.bottom).offset(20)
        }
        
        storeTextField.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.height.equalTo(34)
            make.top.equalTo(countlabel.snp.bottom).offset(15)
        }
        
        recipeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.top.equalTo(drugImageView)
        }
    }
    
    func setupWrapView() {
        
        let wrapperView = UIView()
        addSubview(wrapperView)
        wrapperView.addSubview(price)
        wrapperView.addSubview(buyView)
        
        wrapperView.snp.makeConstraints { make in
            make.top.equalTo(storeTextField.snp.bottom).offset(15)
            make.left.bottom.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(buyView.snp.height).priority(1000)
            make.height.equalTo(price.snp.height).priority(750)
        }
        
        price.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        buyView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
              make.height.equalTo(40)
              make.width.equalTo(132)
        }
    }
    
}
