//
//  IntroView.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 16/03/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class OnBoardingView: UIView {
    
    let imageView = UIImageView()
    let textLabel  = UILabel()
    
    public var viewModel: OnBoardingViewModel! {
        didSet {
            binding()
        }
    }
    
    private let imageSize: Double = 200
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.centerY)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(imageSize)
        }
        
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        
        self.layoutIfNeeded()
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = CGFloat(imageSize * 0.5)
        imageView.clipsToBounds = true
        
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.taPrimary
        textLabel.font = UIFont.normalText
        textLabel.numberOfLines = 0
    }
    
    private func binding() {
        imageView.image = UIImage(named: viewModel.imageName) ?? UIImage()
        textLabel.text   = viewModel.text
    }
    
}
