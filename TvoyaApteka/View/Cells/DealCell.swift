//
//  DealInfoCell.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DealCell: TableViewCardCell {
    
    var viewModel: DealCellModel? {
        didSet {
            binding()
        }
    }
    
    var titleLabel: UILabel {
        return topCard.titleLabel
    }
    
    var subtitleLabel: UILabel {
        return topCard.subtitleLabel
    }
    
    let dealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var timeInfoLabel: UILabel {
        return bottomCard.daysUntilTheEndLabel
    }
    
    var descriptionLabel: UILabel {
        return bottomCard.textShares
    }
    
    private let topCard = DealDetailTopCardView()
    private let bottomCard = DealDetailBottomCardView()
    private let bag = DisposeBag()
    
    override public func applyStyle() {
        super.applyStyle()
        bgView.backgroundColor = .taLightGray
    }
    
    override public func setupLayout() {
        super.setupLayout()
        
        let stackView = UIStackView(arrangedSubviews: [topCard, dealImageView, bottomCard])
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.alignment = .fill
        
        bgView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dealImageView.snp.makeConstraints { make in
            make.height.equalTo(142)
        }
    }
    
    private func binding() {
        self.titleLabel.text = viewModel?.titleText
        self.subtitleLabel.text = viewModel?.subtitleText
        self.dealImageView.setAsyncImage(url: viewModel?.dealImageUrl)
        self.descriptionLabel.text = viewModel?.descriptionText
        viewModel?.timeInfoText.bind(to: timeInfoLabel.rx.text).disposed(by: bag)
    }
    
    deinit {
        viewModel?.destroyTimer()
    }
    
}
