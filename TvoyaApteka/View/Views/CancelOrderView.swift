//
//  CancelOrderView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 16.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class CancelOrderView: UIView {
    
    private let contentView = UIView()
    private let innerContentView = UIView()
    
    private let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h4
        label.text = "Вы можете отменить \nэтот заказ"
        label.numberOfLines = 2
        return label
    }()
    
    private let cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Отменить".uppercased(), for: .normal)
        btn.titleLabel?.font = UIFont.Button.action
        btn.setTitleColor(.red, for: .normal)
        return btn
    }()
    
    private let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    public var cancelHandler: (() -> Void)?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        cancelButton.addTarget(self, action: #selector(cancelHandlerTap), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func cancelHandlerTap() {
        cancelHandler?()
    }
    
    private func setupLayout() {
        addSubview(contentView)
        contentView.addSubview(topLine)
        contentView.addSubview(innerContentView)
        contentView.addSubview(bottomLine)
        innerContentView.addSubview(cancelButton)
        innerContentView.addSubview(infoLabel)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        topLine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        innerContentView.snp.makeConstraints { make in
            make.top.equalTo(topLine.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(bottomLine.snp.top)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(cancelButton.snp.left).offset(-10)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
}
