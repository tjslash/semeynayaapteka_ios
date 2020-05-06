//
//  BaseListController.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

class BaseSelectListController: BaseViewController {
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.rowHeight = Const.tableViewRowHeight
        tableView.estimatedRowHeight = Const.tableViewRowHeight
        tableView.backgroundColor = .clear
        tableView.backgroundView = EmptyListView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        setupLayout()
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
