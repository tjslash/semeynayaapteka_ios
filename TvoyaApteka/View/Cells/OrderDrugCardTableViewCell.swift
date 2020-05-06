//
//  OrderDrugCardTableViewCell.swift
//  TvoyaAptekaInterface
//
//  Created by BuidMac on 14.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class OrderDrugCardTableViewCell: TableViewCardCell {
    
    var viewModel: DrugOrderCellModel? {
        didSet {
            drugCard.viewModel = viewModel
        }
    }
    
    public let drugCard = OrderDrugCardView()
    
    override public func setupLayout() {
        super.setupLayout()
        
        bgView.addSubview(drugCard)
        
        drugCard.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
