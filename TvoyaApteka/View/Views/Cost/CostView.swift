//
//  CostView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 25.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class CostView: UIView {
    
    internal let costLabel = UILabel()
    
    internal let oldCostLabel: UILabel = {
        let label = UILabel()
        label.textColor = .taGray
        return label
    }()
    
    public var cost: String? = nil {
        didSet {
            costLabel.isHidden = (cost == nil)
            costLabel.text = cost
        }
    }
    
    public var oldCost: String? = nil {
        didSet {
            oldCostLabel.isHidden = (oldCost == nil)
            if let oldCost = oldCost {
                let textRange = NSRange(location: 0, length: oldCost.count)
                let attributedText = NSMutableAttributedString(string: oldCost)
                attributedText.addAttribute(NSAttributedStringKey.strikethroughStyle,
                                            value: NSUnderlineStyle.styleSingle.rawValue,
                                            range: textRange)
                oldCostLabel.attributedText = attributedText
            } else {
                oldCostLabel.text = nil
            }
            
        }
    }
    
    public init(layout: LayoutType = .horizontal, font: FontType = .normal) {
        super.init(frame: .zero)
        
        switch layout {
        case .horizontal:
            setupHorizontalLayout()
        case .vertical:
            setupVerticalLayout()
        }
        
        switch font {
        case .normal:
            costLabel.font = UIFont.Title.h3Bold
            oldCostLabel.font = UIFont.Title.h4
        case .large:
            costLabel.font = UIFont.Title.h2Bold
            oldCostLabel.font = UIFont.Title.h3
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHorizontalLayout() {
        let stackView = UIStackView(arrangedSubviews: [costLabel, oldCostLabel])
        stackView.alignment = .leading
        stackView.spacing = 14
        stackView.axis = .horizontal
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupVerticalLayout() {
        let stackView = UIStackView(arrangedSubviews: [costLabel, oldCostLabel])
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.axis = .vertical
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
