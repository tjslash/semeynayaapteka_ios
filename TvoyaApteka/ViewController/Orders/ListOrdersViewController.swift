//
//  ListOrdersPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Parchment

protocol ListOrdersViewControllerDelegate: BaseViewControllerDelegate {
    func selectOrder(id: Int)
}

class ListOrdersViewController: BaseViewController {
    
    public weak var delegate: ListOrdersViewControllerDelegate?
    
    private let bag = DisposeBag()
    private var pagingViewController: FixedPagingViewController!
    private let viewModel: ListOrdersViewModel
    
    init(viewModel: ListOrdersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.uploadOrders()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Список заказов"
        view.backgroundColor = UIColor.taAlmostWhite
        addSearchBarButton()
        binding()
    }

    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    private func binding() {
        viewModel.isUploading
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.orders
            .bind(onNext: { [unowned self] orders in
                self.setupPaginViewController(with: self.makePages(from: orders))
            })
            .disposed(by: bag)
    }
    
    private func makePages(from orders: [Order]) -> [UIViewController] {
        let pageFabric = OrdersPageFabric(orders: orders)
        
        let allOrdersPage = pageFabric.makeAllOrdersPage()
        allOrdersPage.delegate = self
        
        let inProgressOrdersPage = pageFabric.makeinProgressOrdersPage()
        inProgressOrdersPage.delegate = self
        
        let approvedOrdersPage = pageFabric.makeApprovedOrdersPage()
        approvedOrdersPage.delegate = self
        
        let paidOrdersPage = pageFabric.makePaidOrdersPage()
        paidOrdersPage.delegate = self
        
        let doneOrdersPage = pageFabric.makeDoneOrdersPage()
        doneOrdersPage.delegate = self
        
        let cancelOrdersPage = pageFabric.makeCanceledOrdersPage()
        cancelOrdersPage.delegate = self
        
        return [allOrdersPage, inProgressOrdersPage, approvedOrdersPage, paidOrdersPage, doneOrdersPage, cancelOrdersPage]
        
    }
    
    private func setupPaginViewController(with controllers: [UIViewController]) {
        pagingViewController = FixedPagingViewController(viewControllers: controllers)
        addPaginView()
        applyStyle()
    }
    
    private func addPaginView() {
        addChildViewController(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParentViewController: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        pagingViewController.view.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    private func applyStyle() {
        pagingViewController.selectedTextColor = UIColor.white
        pagingViewController.textColor = UIColor.white.withAlphaComponent(0.4)
        pagingViewController.menuBackgroundColor = UIColor.taPrimary
        pagingViewController.backgroundColor = UIColor.taPrimary
        pagingViewController.selectedBackgroundColor = UIColor.taPrimary
        pagingViewController.indicatorColor = UIColor.white
        pagingViewController.view.backgroundColor = UIColor.taAlmostWhite
    }
    
}

// MARK: OrdersPageDelegate
extension ListOrdersViewController: OrdersViewControllerDelegate {
    
    func didSelectSearch() {
        delegate?.didSelectSearch()
    }
    
    func selectOrder(id: Int) {
        delegate?.selectOrder(id: id)
    }
}

class OrdersPageFabric {
    
    private let allOrders: [Order]
    private var approvedOrders: [Order] = []
    private var canceledOrders: [Order] = []
    private var doneOrders: [Order] = []
    private var inProgressOrders: [Order] = []
    private var paidOrders: [Order] = []
    
    init(orders: [Order]) {
        allOrders = orders
        separateOrdersByStatus()
    }
    
    private func separateOrdersByStatus() {
        for order in allOrders {
            switch order.state {
            case .approved:
                approvedOrders.append(order)
            case .canceled:
                canceledOrders.append(order)
            case .done:
                doneOrders.append(order)
            case .inProgress:
                inProgressOrders.append(order)
            case .paid:
                paidOrders.append(order)
            }
        }
    }
    
    func makeAllOrdersPage() -> OrdersViewController {
        let page = OrdersViewController(orders: allOrders)
        page.title = "Все".uppercased()
        return page
    }
    
    func makeApprovedOrdersPage() -> OrdersViewController {
        let page = OrdersViewController(orders: approvedOrders)
        page.title = "Подтвержден".uppercased()
        return page
    }
    
    func makePaidOrdersPage() -> OrdersViewController {
        let page = OrdersViewController(orders: paidOrders)
        page.title = "Оплачен".uppercased()
        return page
    }
    
    func makeinProgressOrdersPage() -> OrdersViewController {
        let page = OrdersViewController(orders: inProgressOrders)
        page.title = "В работе".uppercased()
        return page
    }
    
    func makeDoneOrdersPage() -> OrdersViewController {
        let page = OrdersViewController(orders: doneOrders)
        page.title = "Выполнен".uppercased()
        return page
    }
    
    func makeCanceledOrdersPage() -> OrdersViewController {
        let page = OrdersViewController(orders: canceledOrders)
        page.title = "Отменен".uppercased()
        return page
    }
    
}
