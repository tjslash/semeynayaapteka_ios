//
//  StoreInfoAlert.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

class StoreInfoAlert: UIViewController {
    
    public var didTapButton: (() -> Void)?
    
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let secondaryDescriptionLabel = UILabel()
    private let lineView = UIView()
    private let button = FlatButton(title: "Подробнее".uppercased())
    
    private let store: DrugStore
    
    init(store: DrugStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .taAlmostWhite
        contentView.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapButtonHandler), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelHandler)))
        setupLayout()
        setupUI()
    }
    
    private struct SpacingRules {
        static let left = 12
        static let rigth = -12
        static let top = 14
    }
    
    private func setupLayout() {
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(secondaryDescriptionLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(button)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(270)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(SpacingRules.top)
            make.left.equalToSuperview().offset(SpacingRules.left)
            make.right.equalToSuperview().offset(SpacingRules.rigth)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.left.equalToSuperview().offset(SpacingRules.left)
            make.right.equalToSuperview().offset(SpacingRules.rigth)
        }
        
        secondaryDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(SpacingRules.left)
            make.right.equalToSuperview().offset(SpacingRules.rigth)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(secondaryDescriptionLabel.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.Title.h4Bold
        descriptionLabel.font = UIFont.Title.h4
        secondaryDescriptionLabel.font = UIFont.Title.h4
        secondaryDescriptionLabel.textColor = UIColor.taGray
        lineView.backgroundColor = UIColor.taGray
        
        titleLabel.text = store.title
        descriptionLabel.text = store.address
        secondaryDescriptionLabel.text = store.getScheduleString()
    }
    
    @objc
    private func didTapButtonHandler() {
        didTapButton?()
    }
    
    @objc
    private func cancelHandler() {
        dismiss(animated: true, completion: nil)
    }
    
}
