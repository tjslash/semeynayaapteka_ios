//
//  OrderDetailCardView.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 16/04/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class OrderDetailCardView: CardView {
    
    var viewModel: OrderDetailsCellModel? {
        didSet {
            binding()
        }
    }
    
    public let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .taBlack
        label.font = UIFont.Title.h3Bold
        return label
    }()
    
    public let statusLabel = StatusLabel()
    
    public let dataOrderView: OrderDetailInfoView = {
        let view = OrderDetailInfoView()
        view.imageView.image = #imageLiteral(resourceName: "calendar")
        view.imageView.contentMode = .scaleAspectFit
        view.imageView.tintColor = UIColor.taGray
        view.titleLabel.textColor = .taBlack
        view.titleLabel.font = UIFont.Title.h4
        view.subTitleLabel.textColor = .taBlack
        view.subTitleLabel.font = UIFont.Title.h4
        return view
    }()
    
    public let drugStoreInfoView: OrderDetailInfoView = {
        let view = OrderDetailInfoView()
        view.imageView.image = #imageLiteral(resourceName: "Pin")
        view.imageView.contentMode = .scaleAspectFit
        view.imageView.tintColor = UIColor.taGray
        view.titleLabel.textColor = .taBlack
        view.titleLabel.font = UIFont.Title.h4Bold
        view.subTitleLabel.textColor = .taBlack
        view.subTitleLabel.font = UIFont.Title.h4
        return view
    }()
    
    public let orderCostView: OrderDetailInfoView = {
        let view = OrderDetailInfoView()
        view.imageView.image = #imageLiteral(resourceName: "order_icon")
        view.imageView.contentMode = .scaleAspectFit
        view.imageView.tintColor = UIColor.taPrimary
        view.titleLabel.textColor = .taBlack
        view.titleLabel.font = UIFont.Title.h4
        view.subTitleLabel.textColor = .taBlack
        view.subTitleLabel.font = UIFont.Title.h3Bold
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return view
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct SpacingRules {
        static let top = 16
        static let left = 16
        static let rigth = -16
        static let bottom = -16
        static let lineHeight = 1
        static let descriptionSpacing = 10
    }
    
    private func setupLayout() {
        let titleStackView = UIStackView(arrangedSubviews: [numberLabel, UIView(), statusLabel])
        titleStackView.axis = .horizontal
        
        let descriptionStackView = UIStackView(arrangedSubviews: [dataOrderView, drugStoreInfoView])
        descriptionStackView.axis = .vertical
        descriptionStackView.spacing = CGFloat(SpacingRules.descriptionSpacing)
        descriptionStackView.alignment = .leading
        
        self.addSubview(titleStackView)
        self.addSubview(descriptionStackView)
        self.addSubview(lineView)
        self.addSubview(orderCostView)
        
        statusLabel.snp.makeConstraints { make in
            make.width.equalTo(84)
            make.height.equalTo(20)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(SpacingRules.top)
            make.left.equalToSuperview().offset(SpacingRules.left)
            make.right.equalToSuperview().offset(SpacingRules.rigth)
        }
        
        descriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(SpacingRules.top)
            make.left.equalToSuperview().offset(SpacingRules.left)
            make.right.equalToSuperview().offset(SpacingRules.rigth)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(descriptionStackView.snp.bottom).offset(SpacingRules.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(SpacingRules.lineHeight)
        }
        
        orderCostView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(SpacingRules.top)
            make.left.equalToSuperview().offset(SpacingRules.left)
            make.right.equalToSuperview().offset(SpacingRules.rigth)
            make.bottom.equalToSuperview().offset(SpacingRules.bottom)
        }
    }
    
    private func binding() {
        numberLabel.text = viewModel?.numberText
        statusLabel.text = viewModel?.statusText
        
        dataOrderView.titleLabel.text = viewModel?.createdDateText
        dataOrderView.subTitleLabel.text = viewModel?.createdWeekdayText
        
        drugStoreInfoView.titleLabel.text = viewModel?.drugStoreNameText
        drugStoreInfoView.subTitleLabel.text = viewModel?.drugStoreAddressText
        
        orderCostView.titleLabel.text = "Сумма заказа:"
        orderCostView.subTitleLabel.text = viewModel?.totalCostString
    }
    
}

public class OrderDetailInfoView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    public convenience init(image: UIImage, title: String, subTitle: String) {
        self.init(frame: .zero)
        imageView.image = image
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let verticalStackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.alignment = .leading
        
        let horizontalStackView = UIStackView(arrangedSubviews: [imageView, verticalStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 15
        horizontalStackView.alignment = .center

        self.addSubview(horizontalStackView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
