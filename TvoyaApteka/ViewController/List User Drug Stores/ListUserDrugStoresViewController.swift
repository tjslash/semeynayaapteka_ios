//
//  ListUserStoresPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift

class ListUserDrugStoresViewController: BaseViewController {
    
    private let tableView = UITableView.tableView
    
    private var cellModels: [DrugStoreCellModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let viewModel: ListUserDrugStoresViewModel
    private let bag = DisposeBag()
    
    init( viewModel: ListUserDrugStoresViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        title = "Выберите аптеку"
        setupLayout()
        tableView.dataSource = self
        tableView.delegate = self
        binding()
        viewModel.uploadListStores()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    private func binding() {
        viewModel.cellModels
            .bind(onNext: { [unowned self] models in
                self.cellModels = models
            })
            .disposed(by: bag)
    }
    
}

// MARK: UITableView
extension ListUserDrugStoresViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = (cellModels.count != 0)
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as DrugStoreCell
        cell.viewModel = cellModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelect(store: cellModels[indexPath.row].drugStore)
    }
    
}

private extension UITableView {
    
    static var tableView: UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(DrugStoreCell.self, forCellReuseIdentifier: DrugStoreCell.identifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0)
        tableView.estimatedRowHeight = 165
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.backgroundView = EmptyListView()
        return tableView
    }
    
}
