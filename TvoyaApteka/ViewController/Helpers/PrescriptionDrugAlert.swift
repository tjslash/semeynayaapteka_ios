//
//  PrescriptionDrugAlert.swift
//  TvoyaApteka
//
//  Created by oleg shkreba on 24.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

class PrescriptionDrugAlert: BaseSystemMessageViewController {
    
    // MARK: Public API
    
    /// Title text
    public var titleText: String? {
        get {
            return titleLabel.text
        }
        set(value) {
            titleLabel.text = value
        }
    }
    
    /// Description text
    public var descriptionText: String? {
        get {
            return descriptionLabel.text
        }
        set(value) {
            descriptionLabel.text = value
        }
    }
    
    /// Set action handler when user tap thereIsRecipeButton
    public var didTapDone: (() -> Void)?
    
    // MARK: Private
    private let iconImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "strictly-recipe")
        image.tintColor = UIColor.taRed
        return image
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .taGray
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 2
        lb.textColor = .taBlack
        lb.font = UIFont.Title.h2Bold
        return lb
    }()
    
    private let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textColor = .taGray
        lb.font = UIFont.Title.h3
        return lb
    }()
    
    private let cancelButton: UIButton = {
        let btn = UIButton(title: "Отмена".uppercased())
        btn.setTitleColor(.taGray, for: .normal)
        btn.setTitleColor(.taLightGray, for: .highlighted)
        return btn
    }()
    
    private let thereIsRecipeButton: UIButton = {
        let btn = UIButton(title: "Есть рецепт".uppercased())
        btn.setTitleColor(.taPrimary, for: .normal)
        btn.setTitleColor(.taLightPrimary, for: .highlighted)
        return btn
    }()
    
    @objc
    private func didTapDoneHandler() {
        didTapDone?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func cancelHandler() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.addTarget(self, action: #selector(cancelHandler), for: .touchUpInside)
        thereIsRecipeButton.addTarget(self, action: #selector(didTapDoneHandler), for: .touchUpInside)
    }
    
    override func setupLayout() {
        super.setupLayout()
        let contentWrapperView = UIView()
        
        contentView.addSubview(contentWrapperView)
        contentWrapperView.addSubview(iconImageView)
        contentWrapperView.addSubview(titleLabel)
        contentWrapperView.addSubview(descriptionLabel)
        contentWrapperView.addSubview(cancelButton)
        contentWrapperView.addSubview(lineView)
        contentWrapperView.addSubview(thereIsRecipeButton)
        
        contentWrapperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalTo(55)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            make.left.bottom.equalToSuperview()
        }
        
        thereIsRecipeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(cancelButton)
            make.right.equalToSuperview()
        }
    }
    
}
