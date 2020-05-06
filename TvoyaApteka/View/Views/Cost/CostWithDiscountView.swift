//
//  CostWithDiscountView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 25.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

protocol CostWithDiscountLayoutManager {
    func setup()
    func update()
}

class HorizontalLayoutManaget: CostWithDiscountLayoutManager {
    
    private weak var view: CostWithDiscountView?
    private var costToSuperviewConstaint: Constraint?
    
    init(view: CostWithDiscountView) {
        self.view = view
    }
    
    func setup() {
        guard let view = view else {
            fatalError("view is empty")
        }
        
        view.discountLabel.setContentHuggingPriority(.init(240), for: .horizontal)
        view.discountLabel.setContentCompressionResistancePriority(.init(260), for: .horizontal)
        
        view.addSubview(view.discountLabel)
        view.addSubview(view.costView)
        
        view.discountLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.discountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
            make.width.equalTo(48)
        }
        
        view.costView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(view.discountLabel.snp.right).offset(10).priority(900)
            costToSuperviewConstaint = make.left.equalToSuperview().offset(22).priority(1000).constraint
            make.height.equalTo(45)
            costToSuperviewConstaint?.deactivate()
        }
    }
    
    func update() {
        (view!.discount == nil) ? costToSuperviewConstaint?.activate() : costToSuperviewConstaint?.deactivate()
    }
    
}

class VerticalLayoutManaget: CostWithDiscountLayoutManager {
    
    private weak var view: CostWithDiscountView?
    
    init(view: CostWithDiscountView) {
        self.view = view
    }
    
    func setup() {
        guard let view = view else {
            fatalError("view is empty")
        }
        
        let stackView = UIStackView(arrangedSubviews: [view.discountLabel, view.costView])
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .leading
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func update() {
        
    }
    
}

public enum LayoutType {
    case horizontal, vertical
}

public enum FontType {
    case normal, large
}

public class CostWithDiscountView: UIView {
    
    // MARK: Public API
    public var currentCost: String? = nil {
        didSet {
            costView.cost = currentCost
        }
    }
    
    public var oldCost: String? = nil {
        didSet {
            costView.oldCost = oldCost
        }
    }
    
    public var discount: String? = nil {
        didSet {
            layoutManager.update()
            discountLabel.isHidden = (discount == nil)
            discountLabel.text = discount
        }
    }
    
    // MARK: Private API
    
    fileprivate let costView: CostView
    fileprivate var discountLabel: UILabel!
    
    private var layoutManager: CostWithDiscountLayoutManager!
    
    public init(layout: LayoutType = .horizontal, font: FontType = .normal) {
        self.costView = CostView(layout: .vertical, font: font)
        super.init(frame: .zero)
        self.discountLabel = createDiscountLabel(font: font)
        
        switch layout {
        case .horizontal:
            self.layoutManager = HorizontalLayoutManaget(view: self)
        case .vertical:
            self.layoutManager = VerticalLayoutManaget(view: self)
        }
    
        switch font {
        case .normal:
            self.discountLabel.font = UIFont.Title.h5
        case .large:
            self.discountLabel.font = UIFont.Title.h3
        }
        
        layoutManager.setup()
        applyDefaultInitData()
    }
    
    private func createDiscountLabel(font: FontType) -> UILabel {
        let normalRect = CGRect(x: 0, y: 0, width: 48, height: 28)
        let largeRect = CGRect(x: 0, y: 0, width: 66, height: 28)
        return DiscountLabel(frame: (font == .normal) ? normalRect : largeRect)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyDefaultInitData() {
        discount = nil
        oldCost = nil
        oldCost = nil
    }
    
}

private class DiscountLabel: UILabel {
    
    private let _intrinsicContentSize: CGSize
    
    override init(frame: CGRect) {
        self._intrinsicContentSize = frame.size
        super.init(frame: frame)
        setupBackgroundLayer()
        self.font = UIFont.Title.h5
        self.textColor = .white
        self.textAlignment = .center
        self.backgroundColor = UIColor.taRed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return _intrinsicContentSize
    }
    
    private func setupBackgroundLayer() {
        let rectShape = CAShapeLayer()
        rectShape.path = UIBezierPath(roundedRect: self.frame,
                                      byRoundingCorners: [.bottomRight, .topRight],
                                      cornerRadii: CGSize(width: 4, height: 4)).cgPath
        self.layer.mask = rectShape
    }
    
}
