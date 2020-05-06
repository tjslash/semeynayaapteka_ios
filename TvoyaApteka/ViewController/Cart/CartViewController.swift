//
//  CartPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 09.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

protocol CartViewControllerDelegate: BaseViewControllerDelegate {
    func selectCatalog()
    func selectDrug(_ drug: Drug)
    func successBuy(orders: [Order])
}

class CartViewController: ScrollViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DrugCardTableViewCell.self, forCellReuseIdentifier: DrugCardTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 170
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let attentionView = InfoLabel(text: "Внимание! В Вашем заказе есть рецептурные препараты. " +
        "При выкупе заказа в аптеке необходимо предъявить рецепт фармацевту.")
    
//    private let promocodeView = PromoCodeView()
    private let priceView = CartPriceView()
    private let infoView = CartInfoView()
    private let buyButton = ActionButton(title: "Оформить заказ".uppercased())
    
    private lazy var emptyCartPage: InfoWithActionPage = {
        let configurator = InfoWithActionPage.Configurator(image: #imageLiteral(resourceName: "EmptyBasket"),
                                                           title: "Корзина пуста",
                                                           description: "В Вашей корзине еще ничего нет",
                                                           buttonTitle: "Перейти к покупкам!".uppercased(),
                                                           action: self.showCatalogPage)
        return InfoWithActionPage(configurator: configurator)
    }()
    
    private let countPickerViewPresenter: UIView & CountPickerViewPresenterType = CountPickerViewPresenter()
    
    public weak var delegate: CartViewControllerDelegate?
    
    private var cellModels: [DrugCellModel] = [] {
        didSet {
            tableView.reloadData()
            updateViewConstraints()
        }
    }
    
    private let bag = DisposeBag()
    private let viewModel: CartViewModel
    private let drugStoreRepository: DrugStoreRepositoryType
    
    init(viewModel: CartViewModel, drugStoreRepository: DrugStoreRepositoryType) {
        self.viewModel = viewModel
        self.drugStoreRepository = drugStoreRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Корзина"
        view.backgroundColor = .taAlmostWhite
        addSearchBarButton()
        bindind()
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(tableView.contentSize.height * 1.20)
        }
        
        let stackView = UIStackView(arrangedSubviews: [attentionView, /*promocodeView,*/ priceView, infoView, buyButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
       
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(9)
            $0.left.right.bottom.equalToSuperview().inset(16)
        }
        
        attentionView.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
        
//        promocodeView.snp.makeConstraints { $0.height.equalTo(70) }
        
        priceView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        infoView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        buyButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        contentView.addSubview(countPickerViewPresenter)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        tableView.snp.updateConstraints { make in
            make.height.equalTo(tableView.contentSize.height * 1.20)
        }
    }
    
    private func bindind() {
        buyButton.rx.tap
            .bind(to: viewModel.buyButtonDidTap)
            .disposed(by: bag)
        
        viewModel.cart
            .drive(onNext: { [unowned self] cart in
                self.updateUI(cart)
            })
            .disposed(by: bag)
        
        viewModel.isLoading
            .drive(onNext: { [unowned self] isLoading in
                isLoading ? self.showPreloader() : self.hidePreloader()
            })
            .disposed(by: bag)
        
        viewModel.makeOrderSuccess
            .bind(onNext: { [unowned self] orders in
                self.delegate?.successBuy(orders: orders)
            })
            .disposed(by: bag)
        
        viewModel.messagesError
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
//        promocodeView.promocodeTextField.textField.rx.text
//            .orEmpty
//            .bind(to: viewModel.promoCode)
//            .disposed(by: bag)
//
//        viewModel.promoCodeState
//            .drive(promocodeView.rx.promoState)
//            .disposed(by: bag)
//
//        viewModel.promocodeInputIsUserInteractionEnabled
//            .drive(promocodeView.rx.isUserInteractionEnabled)
//            .disposed(by: bag)
//
//        promocodeView.didTapRightView = { [unowned self] in
//            self.viewModel.applyPromoCode()
//        }
//
//        viewModel.promocode
//            .drive(promocodeView.rx.promoCode)
//            .disposed(by: bag)
        
        viewModel.hasStrictRecipeDrugs
            .map({ $0 == false })
            .drive(attentionView.rx.isHidden)
            .disposed(by: bag)
    }
    
    func makeCellModel(from drug: Drug) -> DrugCellModel {
        let model = DrugCellModel(drug: drug, authManager: AuthManager.shared,
                                  cartManager: CartManager.shared, drugStoreRepository: drugStoreRepository)
        
        model.delegate = self
        return model
    }
    
//    override func handleError(_ error: Error) {
//        guard let serviceError = error as? ServiceError else {
//            super.handleError(error)
//            return
//        }
//
//        switch serviceError {
//        case .notFound:
//            promocodeView.promoState = .wrong
//        case .alreadyUsed:
//            promocodeView.promoState = .alreadyUsed
//        default:
//            super.handleError(error)
//        }
//    }
    
    // MARK: Update UI

    private func updateUI(_ cart: Cart) {
        if cart.isEmpty {
            add(emptyCartPage)
        } else {
            updateCartSum(cart: cart)
            cellModels = cart.items.map({ [unowned self] in self.makeCellModel(from: $0.drug) })
            emptyCartPage.remove()
        }
    }
    
    private func showCatalogPage() {
        delegate?.selectCatalog()
    }
    
    func updateCartSum(cart: Cart) {
        if cart.hasDiscount {
            priceView.cost = PriceFormater.decorated(cart.totalPriceWithPromo)
            priceView.oldCost = PriceFormater.decorated(cart.totalPrice)
        } else {
            priceView.cost = PriceFormater.decorated(cart.totalPrice)
            priceView.oldCost = nil
        }
    }
    
}

// MARK: UITableView
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as DrugCardTableViewCell
        cell.viewModel = cellModels[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.selectDrug(cellModels[indexPath.row].drug)
    }
    
}

// MARK: - DrugBuyInteractorDelegate
extension CartViewController: DrugCellModelDelegate {
    
    func showError(error: Error) {
        handleError(error)
    }
    
    func showAuthorizationAlert() {
        fatalError("Buy from the cart is not possible")
    }
    
    func showRecipeAlert(successHandler: @escaping () -> Void) {
        fatalError("Buy from the cart is not possible")
    }
    
    func showCount(min: Int, max: Int, successHandler: @escaping (Int) -> Void) {
        countPickerViewPresenter.showKeyboard(min: min, max: max, doneHandler: successHandler)
    }
    
}

class PromoCodeView: UIView {
    
    enum PromoStates {
        case start
        case activated
        case wrong
        case alreadyUsed
    }
    
    /// Change state view
    public var promoState: PromoStates? {
        didSet {
            switch promoState ?? .start {
            case .start: setNotActiveStateTitle()
            case .activated: setActiveStateTitle()
            case .wrong: setWrongPromocode()
            case .alreadyUsed: setAlreadyUsedPromocode()
            }
        }
    }
    
    /// Set action on tap
    public var didTapRightView: (() -> Void)? {
        didSet {
            promocodeTextField.didTapRightView = didTapRightView
        }
    }
    
    public var promoText: String? {
        get { return promocodeTextField.textField.text }
        set { promocodeTextField.textField.text = newValue }
    }
    
    // MARK: Private API
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.Title.h4Bold
        return label
    }()
    
    let promocodeTextField = PromocodeInputView()
    
    private func setActiveStateTitle() {
        titleLabel.text = "Промокод успешно активирован".uppercased()
        titleLabel.textColor = .taGray
        promocodeTextField.rightView.backgroundColor = .taGreen
    }
    
    private func setNotActiveStateTitle() {
        titleLabel.text = "Активировать промо код".uppercased()
        titleLabel.textColor = .taPrimary
        promocodeTextField.rightView.backgroundColor = .taPrimary
    }
    
    private func setWrongPromocode() {
        titleLabel.text = "Неверный промо код".uppercased()
        titleLabel.textColor = .taGray
        promocodeTextField.rightView.backgroundColor = .taPrimary
    }
    
    private func setAlreadyUsedPromocode() {
        titleLabel.text = "Промо код уже использован".uppercased()
        titleLabel.textColor = .taGray
        promocodeTextField.rightView.backgroundColor = .taPrimary
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setNotActiveStateTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(promocodeTextField)
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        promocodeTextField.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(32)
        }
    }
    
}

private class CartPriceView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h3Bold
        label.text = "Итого:"
        return label
    }()
    
    private let costView = CostView()
    
    public var cost: String? {
        didSet {
            costView.cost = cost
        }
    }
    
    public var oldCost: String? {
        didSet {
            costView.oldCost = oldCost
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(costView)
        
        titleLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
        }
        
        costView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func convertToCostString(_ cost: Double) -> String {
        return "\(cost) руб."
    }
    
}

private class CartInfoView: UIView {
    
    private let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .taGray
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "receiving-time"))
        imageView.tintColor = UIColor.taPrimary
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h5
        label.numberOfLines = 2
        label.text = "Все товары в заказе резервируются на 24 часа, после этого заказ автоматически отменяется"
        return label
    }()
    
    private let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .taGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(topLine)
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(bottomLine)
        
        topLine.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.left.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(10)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
