//
//  DrugCardTableViewCell.swift
//  TvoyaApteka
//
//  Created by BuidMac on 25.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class DrugCardTableViewCell: TableViewCardCell {
    
    public let drugCard = DrugCardView()
    
    var viewModel: DrugCellModel? {
        didSet {
            drugCard.viewModel = viewModel
        }
    }
    
    override public func setupLayout() {
        super.setupLayout()
        
        bgView.addSubview(drugCard)
        
        drugCard.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
