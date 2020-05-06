//
//  BuyActionView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 26.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public enum PurchaseStatus {
    case bought(count: Int), boughtNotEditable(count: Int), notBought
}

public protocol BuyActionItem {
    func startWaiting()
    func stopWaiting()
}

public class BuyActionView: UIView {
    
    /// Set status view
    public var status: PurchaseStatus {
        didSet {
            changeStatus(status)
        }
    }
    
    /// Cancel animation waiting view
    public func cancelAllWaitingAnimations() {
        buyButton.stopWaiting()
        addButton.stopWaiting()
        deleteButton.stopWaiting()
    }
    
    public let buyButton: UIButton & BuyActionItem =  BuyButton(title: "В Корзину".uppercased())
    public let addButton: UIButton & BuyActionItem = CountButton()
    public let deleteButton: UIButton & BuyActionItem = DeleteButton()
    
    public init(status: PurchaseStatus = .notBought) {
        self.status = status
        super.init(frame: .zero)
        setupLayout()
        changeStatus(status)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Height. by default is equal to superview
    public var buyButtonHeightConstraint: Constraint!
    
    // MARK: Private API
    private func setupLayout() {
        let contentView = UIView()
    
        addSubview(contentView)
        contentView.addSubview(buyButton)
        contentView.addSubview(addButton)
        contentView.addSubview(deleteButton)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buyButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
            buyButtonHeightConstraint = make.height.equalToSuperview().constraint
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(deleteButton.snp.height)
            make.centerY.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { (make) in
            make.right.equalTo(deleteButton.snp.left).offset(-10)
            make.size.equalTo(deleteButton)
            make.centerY.equalTo(deleteButton)
        }
    }
    
    private func changeStatus(_ status: PurchaseStatus) {
        switch status {
        case .bought(let count):
            buyButton.isHidden = true
            deleteButton.isHidden = false
            addButton.isHidden = false
            addButton.setTitle("\(count)", for: .normal)
        case .boughtNotEditable(let count):
            buyButton.isHidden = true
            deleteButton.isHidden = true
            addButton.isHidden = false
            addButton.setTitle("\(count)", for: .normal)
        case .notBought:
            buyButton.isHidden = false
            deleteButton.isHidden = true
            addButton.isHidden = true
        }
    }

}

// MARK: - Items
private class DeleteButton: RoundButton, BuyActionItem {
    
    private let activity = UIActivityIndicatorView()
    private let buttonIcon = #imageLiteral(resourceName: "Delete")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(buttonIcon, for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.taRed.cgColor
        addActivityIndicator()
        activity.color = .taRed
    }
    
    func addActivityIndicator() {
        addSubview(activity)
        
        activity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startWaiting() {
        activity.startAnimating()
        self.setImage(nil, for: .normal)
    }
    
    func stopWaiting() {
        activity.stopAnimating()
        self.setImage(buttonIcon, for: .normal)
    }
    
}

private class BuyButton: ActionButton, BuyActionItem {
    
    func startWaiting() {
        self.alpha = 0.5
    }
    
    func stopWaiting() {
        self.alpha = 1.0
    }
    
}

private class CountButton: RoundButton, BuyActionItem {
    
    private let activity = UIActivityIndicatorView()
    private var textColor = UIColor.taGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.taGray.cgColor
        self.layer.borderWidth = 1
        self.setTitleColor(textColor, for: .normal)
        activity.color = textColor
        addActivityIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addActivityIndicator() {
        addSubview(activity)
        
        activity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func startWaiting() {
        activity.startAnimating()
        self.setTitleColor(.clear, for: .normal)
    }
    
    func stopWaiting() {
        activity.stopAnimating()
        self.setTitleColor(textColor, for: .normal)
    }
    
}
