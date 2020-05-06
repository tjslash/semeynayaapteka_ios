//
//  DrugCardView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 25.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public class DrugCardView: UIView {
    
    // MARK: Public API
    
    var viewModel: DrugCellModel? {
        didSet {
            binding()
        }
    }
    
    public let buyView: BuyActionView = {
        let view = BuyActionView(status: .notBought)
        view.buyButtonHeightConstraint.deactivate()
        return view
    }()
    
    public let priceView = CostWithDiscountView()
    
    public var recipeStatus: RecipeStatus = .none {
        didSet {
            switch recipeStatus {
            case .recipe:
                recipeImageView.tintColor = .taRed
                recipeImageView.backgroundColor = .taAlmostWhite
                recipeImageView.isHidden = false
            case .recipe2:
                recipeImageView.tintColor = .taPrimary
                recipeImageView.backgroundColor = .taAlmostWhite
                recipeImageView.isHidden = false
            default:
                recipeImageView.isHidden = true
                recipeImageView.backgroundColor = .clear
            }
        }
    }
    
    public var drugImageView: UIImageView {
        return nameView.drugImageView
    }
    
    public var title: String? {
        didSet {
            nameView.drugNameLabel.text = title
        }
    }
    
    public var secondaryTitle: String? {
        didSet {
            nameView.secondaryDrugNameLabel.text = secondaryTitle
        }
    }
    
    public var purchaseStatus: PurchaseStatus = .notBought {
        didSet {
            buyView.status = purchaseStatus
        }
    }
    
    public var closeButtonIsHidden: Bool = true {
        didSet {
            closeButton.isHidden = closeButtonIsHidden
        }
    }
    
    public var addressId: Int? {
        get { return storeTextField.selectedId }
        set {
            if let id = newValue {
                storeTextField.setSelectedId(id: id)
            }
        }
    }
    
    public var addresses: [Int: NSAttributedString] = [:] {
        didSet {
            storeTextField.dataSource = addresses
            storeTextField.selectedRow = 0
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            self.buyView.buyButton.isEnabled = isEnabled
            self.buyView.addButton.isEnabled = isEnabled
            self.buyView.deleteButton.isEnabled = isEnabled
            self.storeTextField.textField.isEnabled = isEnabled
            self.storeTextField.rightView.isHidden = !isEnabled
        }
    }
    
    public var didTapBuy: (() -> Void)?
    public var didTapAdd: (() -> Void)?
    public var didTapDelete: (() -> Void)?
    public var didTapClose: (() -> Void)?
    public var didChangedAdress: ((Int) -> Void)?
    
    // MARK: Private view
    private let nameView = DrugNameView()
    
    private lazy var storeTextField: AddressDropListView = {
        let addressField = AddressDropListView()
        addressField.didChangedAdress = { [unowned self] id in self.didChangedAdress?(id) }
        return addressField
    }()
    
    private let recipeImageView = UIImageView(image: #imageLiteral(resourceName: "strictly-recipe"))
    
    private lazy var closeButton: UIButton = {
        let btn = RoundButton()
        btn.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
        btn.layer.borderColor = UIColor.taLightGray.cgColor
        btn.addTarget(self, action: #selector(tapCloseHandler), for: .touchUpInside)
        btn.layer.borderWidth = 2
        return btn
    }()
    
    private var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        applyDefaultStyle()
        bindButtons()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private metods
    private func bindButtons() {
        buyView.buyButton.addTarget(self, action: #selector(tapBuyHandler), for: .touchUpInside)
        buyView.addButton.addTarget(self, action: #selector(tapAddHandler), for: .touchUpInside)
        buyView.deleteButton.addTarget(self, action: #selector(tapDeleteHandler), for: .touchUpInside)
    }
    
    private func applyDefaultStyle() {
        recipeStatus = .none
        drugImageView.image = nil
        closeButtonIsHidden = true
    }
    
    private struct SpacingRule {
        static let left = 22
        static let right = -22
        static let top = 20
        static let bottom = -8
        static let innerPadding = 13
    }
    
    private func setupLayout() {
        addSubview(nameView)
        addSubview(storeTextField)
        addSubview(recipeImageView)
        addSubview(buyView)
        addSubview(priceView)
        addSubview(closeButton)
        
        nameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(SpacingRule.top)
            make.left.equalToSuperview().offset(SpacingRule.left)
            make.right.equalToSuperview().offset(SpacingRule.right + (-30))
        }
        
        storeTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SpacingRule.left)
            make.right.equalToSuperview().offset(SpacingRule.right)
            make.height.equalTo(32)
            make.top.equalTo(nameView.snp.bottom).offset(SpacingRule.innerPadding)
        }
        
        buyView.snp.makeConstraints { make in
            make.top.equalTo(storeTextField.snp.bottom).offset(SpacingRule.innerPadding)
            make.right.equalToSuperview().offset(SpacingRule.right)
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.bottom.equalToSuperview().offset(SpacingRule.bottom)
        }
        
        priceView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(buyView)
        }
        
        closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(32)
        }
        
        recipeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
        }
    }
    
    private func binding() {
        title = viewModel?.titleText
        drugImageView.image = #imageLiteral(resourceName: "NoPhoto")
        drugImageView.setAsyncImage(url: viewModel?.drugImageUrl)
        recipeStatus = viewModel?.recipeStatus ?? .none
        priceView.currentCost = viewModel?.currentCostText
        priceView.oldCost = viewModel?.oldCostText
        priceView.discount = viewModel?.discountText
    
        viewModel?.secondaryText
            .bind(to: nameView.secondaryDrugNameLabel.rx.text)
            .disposed(by: bag)
        
        viewModel?.allDrugStores
            .bind(onNext: { [unowned self] addresses in
                self.addresses = addresses
            })
            .disposed(by: bag)
        
        viewModel?.currentDrugStoreId
            .bind(onNext: { [unowned self] id in
                self.addressId = id
            })
            .disposed(by: bag)
        
        viewModel?.purchaseStatus
            .bind(onNext: { [weak self] status in
                self?.purchaseStatus = status
            })
            .disposed(by: bag)
        
        didTapBuy = { [unowned self] in self.viewModel?.buyDrug() }
        didTapAdd = { [unowned self] in self.viewModel?.changeCountDrug() }
        didTapDelete = { [unowned self] in self.viewModel?.deleteDrug() }
        didChangedAdress = { [unowned self] id in self.viewModel?.changeDrugStore(id: id) }
        
        viewModel?.isBuyAnimation
            .bind(onNext: { [unowned self] isAnimate in
                self.animatedButton(self.buyView.buyButton, isAnimate: isAnimate)
            })
            .disposed(by: bag)
        
        viewModel?.isAddAnimation
            .bind(onNext: { [unowned self] isAnimate in
                self.animatedButton(self.buyView.addButton, isAnimate: isAnimate)
            })
            .disposed(by: bag)
        
        viewModel?.isDeleteAnimation
            .bind(onNext: { [unowned self] isAnimate in
                self.animatedButton(self.buyView.deleteButton, isAnimate: isAnimate)
            })
            .disposed(by: bag)
        
        viewModel?.viewIsEnable
            .bind(onNext: { [weak self] isEnabled in
                self?.isEnabled = isEnabled
            })
            .disposed(by: bag)
    }
    
    private func animatedButton(_ button: BuyActionItem, isAnimate: Bool) {
        isAnimate ? button.startWaiting() : button.stopWaiting()
        self.isUserInteractionEnabled = !isAnimate
    }
    
    @objc
    private func tapBuyHandler() {
        didTapBuy?()
    }
    
    @objc
    private func tapAddHandler() {
        didTapAdd?()
    }
    
    @objc
    private func tapDeleteHandler() {
        didTapDelete?()
    }
    
    @objc
    private func tapCloseHandler() {
        didTapClose?()
    }
    
}

public enum RecipeStatus {
    case none, recipe, recipe2
}
