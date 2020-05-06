//
//  OrderDrugCardView.swift
//  TvoyaAptekaInterface
//
//  Created by BuidMac on 14.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class OrderDrugCardView: UIView {
    
    var viewModel: DrugOrderCellModel? {
        didSet {
            binding()
        }
    }
    
    public var countText: String? {
        get {
            return countLabel.text
        }
        set(value) {
            countLabel.text = value
        }
    }
    
    public let priceView = CostWithDiscountView()
    
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
    
    public var drugImageView: UIImageView {
        return nameView.drugImageView
    }
    
    public var title: String? {
        didSet {
            nameView.drugNameLabel.text = title
        }
    }
    
    public var secondaryTitle: String? {
        didSet {
            nameView.secondaryDrugNameLabel.text = secondaryTitle
        }
    }
    
    // MARK: Private
    
    private let nameView = DrugNameView()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .taGray
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .taGray
        label.numberOfLines = 2
        return label
    }()
    
    private let recipeImageView = UIImageView(image: #imageLiteral(resourceName: "strictly-recipe"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        applyDefaultStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyDefaultStyle() {
        recipeStatus = .none
        drugImageView.image = nil
    }
    
    private struct SpacingRule {
        static let left = 22
        static let right = -22
        static let top = 20
        static let bottom = -8
        static let innerPadding = 13
    }
    
    private func setupLayout() {
        addSubview(nameView)
        addSubview(lineView)
        addSubview(recipeImageView)
        let bottomWrapper = UIView()
        addSubview(bottomWrapper)
        bottomWrapper.addSubview(priceView)
        bottomWrapper.addSubview(countLabel)
        
        nameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(SpacingRule.top)
            make.left.equalToSuperview().offset(SpacingRule.left)
            make.right.equalToSuperview().offset(SpacingRule.right + (-30))
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(nameView.snp.bottom).offset(SpacingRule.innerPadding)
        }
        
        recipeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
        }
        
        bottomWrapper.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(SpacingRule.innerPadding)
            make.right.equalToSuperview().offset(SpacingRule.right)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(SpacingRule.bottom)
            make.height.equalTo(50)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(SpacingRule.right)
        }
        
        priceView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }

    }
    
    private func binding() {
        title = viewModel?.titleText
        secondaryTitle = "В наличии"
        drugImageView.image = #imageLiteral(resourceName: "NoPhoto")
        drugImageView.setAsyncImage(url: viewModel?.drugImageUrl)
        countText = viewModel?.countText
        priceView.currentCost = viewModel?.currentCostText
        priceView.oldCost = viewModel?.oldCostText
        priceView.discount = viewModel?.discountText
    }
    
}
