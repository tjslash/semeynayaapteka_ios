//
//  OrdersDrugTableView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift

class OrdersDrugTableView: UITableView {
    
    public var cancelOrder: (() -> Void)?
    public var didSelect: ((Drug) -> Void)?
    
    public var orderCanBeCanceled = false {
        didSet {
            self.sectionFooterHeight = orderCanBeCanceled ? 70 : 0
            self.estimatedSectionFooterHeight = orderCanBeCanceled ? 70 : 0
        }
    }
    
    public var cellModels: [DrugOrderCellModel] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cancelOrderView = CancelOrderView()
    
    private func setupTableView() {
        self.register(OrderDrugCardTableViewCell.self, forCellReuseIdentifier: OrderDrugCardTableViewCell.identifier)
        self.dataSource = self
        self.delegate = self
        self.isScrollEnabled = false
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 165
        self.sectionHeaderHeight = 50
        self.estimatedSectionHeaderHeight = 50
        self.separatorStyle = .none
        self.backgroundColor = .clear
    }
    
}

extension OrdersDrugTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as OrderDrugCardTableViewCell
        cell.viewModel = cellModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let view = UIView()
        view.addSubview(label)
        label.snp.makeConstraints {$0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))}
        label.text = "Товары в заказе"
        label.font = UIFont.Title.h4
        label.textColor = .taBlack
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        cancelOrderView.cancelHandler = { [weak self] in
            self?.cancelOrder?()
        }
        if orderCanBeCanceled {
            return cancelOrderView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drug = cellModels[indexPath.row].drug
        didSelect?(drug)
    }
    
}
