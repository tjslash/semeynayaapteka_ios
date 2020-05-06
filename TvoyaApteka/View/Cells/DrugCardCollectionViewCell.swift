//
//  DrugCardCollectionViewCell.swift
//  TvoyaApteka
//
//  Created by BuidMac on 26.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class DrugCardCollectionViewCell: CollectionViewCardCell {
    
    let drugCard = DrugCardView()
    
    var viewModel: DrugCellModel? {
        didSet {
            drugCard.viewModel = viewModel
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drugCard.drugImageView.image = #imageLiteral(resourceName: "NoPhoto")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func setupLayout() {
        super.setupLayout()
        
        bgView.addSubview(drugCard)
        
        drugCard.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
