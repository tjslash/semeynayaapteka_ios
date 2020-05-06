//
//  OrderDetailCardСell.swift
//  TvoyaApteka
//
//  Created by BuidMac on 16.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

class OrderDetailCardСell: TableViewCardCell {
    
    let cardView = OrderDetailCardView()
    
    var viewModel: OrderDetailsCellModel? {
        didSet {
            cardView.viewModel = viewModel
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        bgView.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
