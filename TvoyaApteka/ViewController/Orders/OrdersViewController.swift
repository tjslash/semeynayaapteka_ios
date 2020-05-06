//
//  OrdersPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift

protocol OrdersViewControllerDelegate: BaseViewControllerDelegate {
    func selectOrder(id: Int)
}

class OrdersViewController: BaseViewController {
    
    public weak var delegate: OrdersViewControllerDelegate?
    
    private var cellModel: [OrderCellModel] = []
    private let bag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderCell.self, forCellReuseIdentifier: OrderCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 110
        tableView.estimatedRowHeight = 110
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.backgroundView = EmptyListView()
        return tableView
    }()
    
    init(orders: [Order]) {
        super.init(nibName: nil, bundle: nil)
        self.cellModel = orders.map({ OrderCellModel(order: $0) })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = UIColor.taAlmostWhite
        title = "Полезная информация"
        addSearchBarButton()
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
    
}

// MARK: UITableView
extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = (cellModel.count != 0)
        return cellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as OrderCell
        cell.viewModel = cellModel[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.selectOrder(id: cellModel[indexPath.row].order.id)
    }
    
}
