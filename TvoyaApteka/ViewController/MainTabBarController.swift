//
//  MainTabBarController.swift
//  TvoyaApteka
//
//  Created by BuidMac on 06.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import Chat
import RxSwift

protocol MainTabBarControllerDelegate: class {
    func selectMenuFlow(navigationController: UINavigationController)
    func selectCatalogFlow(navigationController: UINavigationController)
    func shouldSelectCartFlow() -> Bool
    func selectCartFlow(navigationController: UINavigationController)
    func selectHotCallFlow(navigationController: UINavigationController)
    func selectChatFlow(navigationController: UINavigationController)
}

class MainTabBarController: UITabBarController {
    
    public weak var coordinatorDelegate: MainTabBarControllerDelegate?
    
    public var visibleViewController: UIViewController? {
        return self.viewControllers?[self.selectedIndex]
    }
    
    private let bag = DisposeBag()
    private let cartManager: CartManagerType
    
    private let cartPage: UINavigationController = {
        let page = UINavigationController()
        page.tabBarItem.image = #imageLiteral(resourceName: "Basket")
        page.title = "Корзина"
        
        if #available(iOS 10.0, *) {
            page.tabBarItem.badgeColor = UIColor.taPrimary
        }
        
        return page
    }()
    
    init(cartManager: CartManagerType) {
        self.cartManager = cartManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        delegate = self
        
        cartManager.cart
            .asDriver()
            .drive(onNext: { [unowned self] cart in
                let totalCountItems = cart.items.map({ $0.count }).reduce(0, +)
                let countString = totalCountItems == 0 ? nil : String(totalCountItems)
                self.cartPage.tabBarItem.badgeValue = countString
            }).disposed(by: bag)
    }
    
    private func setupTabs() {
        let menuPage = UINavigationController()
        menuPage.tabBarItem.image = #imageLiteral(resourceName: "Menu")
        menuPage.title = "Меню"
        
        let catalogPage = UINavigationController()
        catalogPage.tabBarItem.image = #imageLiteral(resourceName: "vitamins")
        catalogPage.title = "Каталог"
        
        let callPage = UINavigationController()
        callPage.tabBarItem.image = #imageLiteral(resourceName: "Phone")
        callPage.title = "Справка"
        
        let chatPage = UINavigationController()
        chatPage.tabBarItem.image = #imageLiteral(resourceName: "Speech-bubble")
        chatPage.title = "Чат"
        
        viewControllers = [catalogPage, callPage, chatPage, cartPage, menuPage]
    }
    
    public func showCatalog() {
        self.selectedIndex = 0
        
        if let controller = self.viewControllers?[selectedIndex] as? UINavigationController {
            coordinatorDelegate?.selectCatalogFlow(navigationController: controller)
        }
    }
    
    public func showCart() {
        self.selectedIndex = 3
        
        if let controller = self.viewControllers?[selectedIndex] as? UINavigationController {
            coordinatorDelegate?.selectCartFlow(navigationController: controller)
        }
    }
    
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[tabBarController.selectedIndex] as? UINavigationController else { return }

        switch tabBarController.selectedIndex {
        case 0:
            coordinatorDelegate?.selectCatalogFlow(navigationController: controller)
        case 1:
            coordinatorDelegate?.selectHotCallFlow(navigationController: controller)
        case 2:
            coordinatorDelegate?.selectChatFlow(navigationController: controller)
        case 3:
            coordinatorDelegate?.selectCartFlow(navigationController: controller)
        case 4:
            coordinatorDelegate?.selectMenuFlow(navigationController: controller)
        default:
            break
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController === tabBarController.viewControllers![3] {
            return coordinatorDelegate?.shouldSelectCartFlow() ?? false
        }
        
        return true
    }
    
}
