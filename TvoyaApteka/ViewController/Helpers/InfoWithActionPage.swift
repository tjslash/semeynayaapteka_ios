//
//  InfoWithActionPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 24.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

class InfoWithActionPage: BaseViewController {
    
    struct Configurator {
        var image: UIImage
        var title: String
        var description: String
        var buttonTitle: String
        var action: (() -> Void)?
    }
    
    public let configurator: Configurator
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h2Bold
        label.textColor = .taBlack
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h3
        label.textColor = .taGray
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private let actionButton = ActionButton()
    public var customAction: (() -> Void)?
    
    init(configurator: Configurator) {
        self.configurator = configurator
        super.init(nibName: nil, bundle: nil)
        setupContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.taAlmostWhite
        setupLayout()
        actionButton.addTarget(self, action: #selector(actionHandler), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let contentView = UIView()
        
        view.addSubview(contentView)
        contentView.addSubview(actionButton)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(300)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(94)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(44)
            make.left.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.bottom.right.left.equalToSuperview()
            make.height.equalTo(48)
        }
    }
    
    private func setupContent() {
        imageView.image = configurator.image
        titleLabel.text = configurator.title
        descriptionLabel.text = configurator.description
        actionButton.setTitle(configurator.buttonTitle, for: .normal)
        customAction = configurator.action
    }
    
    @objc
    private func actionHandler() {
        customAction?()
    }
    
}
