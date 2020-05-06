//
//  MenuPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 09.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift

protocol MenuViewControllerDelegate: BaseViewControllerDelegate {
    func selectChangeCity()
    func selectChangeStore()
    func selectCatalog()
    func selectListOrders()
    func selectFavoriteDrug()
    func selectBonusCard()
    func selectListDeals()
    func selectListNews()
    func selectProfile()
    func selectListStore()
    func selectReview()
}

class MenuViewController: BaseViewController {
    
    public weak var delegate: MenuViewControllerDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 55
        tableView.estimatedRowHeight = 55
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = 0
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private let defaultCityLabel = "Выберите город"
    private let defaultStoreLabel = "Выберите ближайшую аптеку"
    private lazy var userCityMenuItem: MenuItem = MenuItem(image: UIImage(named: "placeholder"),
                                                           title: defaultCityLabel,
                                                           action: delegate?.selectChangeCity)
    
    private lazy var userStoreMenuItem: MenuItem = MenuItem(image: UIImage(named: "home"),
                                                            title: defaultStoreLabel,
                                                            action: delegate?.selectChangeStore)
    
    private var menuItems: [[MenuItem]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Меню"
        view.backgroundColor = UIColor.taAlmostWhite
        setupLayout()
        makeMenuItem()
        addSearchBarButton()
        
        loadUserCityAndStore()
        bindCityAndStore()
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    private func loadUserCityAndStore() {
        setCityItem(city: AppConfiguration.shared.currentCity)
        setStoreItem(store: AppConfiguration.shared.favoriteDrugStore.value)
    }
    
    private func bindCityAndStore() {
        AppConfiguration.shared.favoriteDrugStore
            .asDriver()
            .drive(onNext: { [weak self] store in
                self?.setStoreItem(store: store)
            }).disposed(by: bag)
    }
    
    private func setCityItem(city: City?) {
        if let city = city {
            userCityMenuItem.title = city.title
        } else {
            userCityMenuItem.title = defaultCityLabel
        }
        makeMenuItem()
    }
    
    private func setStoreItem(store: DrugStore?) {
        if let store = store {
            let label = store.title + " ( " + store.address + " )"
            userStoreMenuItem.title = label
        } else {
            userStoreMenuItem.title = defaultStoreLabel
        }
        makeMenuItem()
    }
}

extension MenuViewController {
    
    private func makeMenuItem() {
        menuItems = [
            [ userCityMenuItem, userStoreMenuItem ],
            [
                MenuItem(image: UIImage(named: "vitamins"), title: "Каталог товаров", action: delegate?.selectCatalog),
                MenuItem(image: UIImage(named: "clipboards"), title: "Список заказов", action: delegate?.selectListOrders),
                MenuItem(image: UIImage(named: "heart-menu"), title: "Избранные товары", action: delegate?.selectFavoriteDrug),
                MenuItem(image: UIImage(named: "credit-card"), title: "Дисконтная карта", action: delegate?.selectBonusCard),
                MenuItem(image: UIImage(named: "star"), title: "Акции", action: delegate?.selectListDeals),
                MenuItem(image: UIImage(named: "info"), title: "Полезная информация", action: delegate?.selectListNews),
                MenuItem(image: UIImage(named: "user"), title: "Профиль", action: delegate?.selectProfile),
                MenuItem(image: UIImage(named: "hospital-sign"), title: "Адреса аптек", action: delegate?.selectListStore),
                MenuItem(image: UIImage(named: "email"), title: "Обратная связь", action: delegate?.selectReview)
            ]]
    }

}

// MARK: UITableView
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MenuItemCell
        cell.iconImageView.image = menuItems[indexPath.section][indexPath.row].image
        cell.iconImageView.tintColor = UIColor.taBlack
        cell.iconImageView.contentMode = .center
        cell.titleLabel.text = menuItems[indexPath.section][indexPath.row].title
        cell.titleLabel.textColor = indexPath.section == 0 ? UIColor.taPrimary : UIColor.taBlack
        cell.titleLabel.font = indexPath.section == 0 ? UIFont.Title.h3Bold : UIFont.Title.h3
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        menuItems[indexPath.section][indexPath.row].action?()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section == 0 ? SepatationLineView() : nil
    }
    
}

struct MenuItem {
    let image: UIImage?
    var title: String
    let action: (() -> Void)?
    
    init(image: UIImage?, title: String, action: (() -> Void)?) {
        self.image = image
        self.title = title
        self.action = action
    }
}

// Override standart cell
class MenuItemCell: UITableViewCell {
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(17)
            make.height.width.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-17)
        }
    }
    
}

private class SepatationLineView: UIView {
    private let line = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(line)
        
        line.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
        }
        
        line.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
