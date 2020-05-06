//
//  ListCategoryPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

protocol ListCategoryViewControllerDelegate: BaseViewControllerDelegate {
    func selectItem(_ category: DrugCategory)
}

class ListCategoryViewController: BaseViewController {
    
    public weak var delegate: ListCategoryViewControllerDelegate?
    
    private let tableView = UITableView.tableView
    private let category: [DrugCategory]
    
    init(category: [DrugCategory]) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        addSearchBarButton()
        tableView.dataSource = self
        tableView.delegate = self
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
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
}

// MARK: UITableView
extension ListCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = (category.count != 0)
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = category[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = .taPrimary
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard category.indices.contains(indexPath.row) else { return }
        delegate?.selectItem(category[indexPath.row])
    }
    
}

// MARK: Static UITableView fabric
private extension UITableView {
    
    static var tableView: UITableView {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.rowHeight = Const.tableViewRowHeight
        tableView.estimatedRowHeight = Const.tableViewRowHeight
        tableView.backgroundColor = .clear
        tableView.backgroundView = EmptyListView()
        return tableView
    }
    
}
