//
//  SuccessAlert.swift
//  TvoyaApteka
//
//  Created by oleg shkreba on 24.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

class SystemAlert: BaseSystemMessageViewController {
    
    // MARK: Private API
    
    /// Alert button text
    public var buttonTitleText: String? {
        get {
            return saveButton.titleLabel?.text
        }
        set(value) {
            saveButton.setTitle(value, for: .normal)
        }
    }
    
    /// Title label
    public var titleText: String? {
        get {
            return titleLabel.text
        }
        set(value) {
            titleLabel.text = value
        }
    }
    
    /// Description label
    public var descriptionText: String? {
        get {
            return descriptionLabel.text
        }
        set(value) {
            descriptionLabel.text = value
        }
    }
    
    /// Alert image
    public var icon: UIImage? {
        get {
            return iconImageView.image
        }
        set(value) {
            iconImageView.image = value
        }
    }
    
    // MARK: Private
    private let iconImageView: UIImageView = {
        let image = UIImageView()
        return image
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .taBlack
        label.font = UIFont.Title.h2Bold
        return label
    } ()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .taGray
        label.font = UIFont.Title.h3
        return label
    } ()
    
    private let saveButton = FlatButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    override func setupLayout() {
        super.setupLayout()
        let contentWrapperView = UIView()
        
        contentView.addSubview(contentWrapperView)
        contentWrapperView.addSubview(iconImageView)
        contentWrapperView.addSubview(titleLabel)
        contentWrapperView.addSubview(descriptionLabel)
        contentWrapperView.addSubview(saveButton)
        
        contentWrapperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(45)
            make.right.equalToSuperview().offset(-45)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(123)
            make.width.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.bottom.equalToSuperview()
            make.left.right.lessThanOrEqualToSuperview()
        }
    }
    
    @objc
    private func closeAction() {
        dismiss(animated: false, completion: nil)
    }
    
}
