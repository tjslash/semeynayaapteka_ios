//
//  SearchResultsPage.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 21/05/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift

class SearchDrugListViewController: BaseViewController {
    
    private let tableView = UITableView.tableView
    
    private var cellModels: [DrugCellModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let bag = DisposeBag()
    private let countPickerViewPresenter: UIView & CountPickerViewPresenterType = CountPickerViewPresenter()
    private let viewModel: SearchDrugListViewModel
    
    init(viewModel: SearchDrugListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        setupLayout()
        tableView.delegate = self
        tableView.dataSource = self
        binding()
    }
    
    private func setupLayout() {
        view.addSubview(countPickerViewPresenter)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func binding() {
        viewModel.cellModels
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] models in
                self.cellModels = models
            })
            .disposed(by: bag)
        
        viewModel.showRecipeAlert = { [unowned self] doneHandler in
            self.showPrescriptionDrugAlert(completion: doneHandler)
        }
        
        viewModel.showCount = { [unowned self] min, max, successHandler in
            self.countPickerViewPresenter.showKeyboard(min: min, max: max, doneHandler: successHandler)
        }
    }
    
}

// MARK: - UITableViewDelegate
extension SearchDrugListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = (cellModels.count != 0)
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as DrugCardTableViewCell
        cell.viewModel = cellModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelected(drug: cellModels[indexPath.row].drug)
    }
    
}

// MARK: Static UITableView fabric
private extension UITableView {
    
    static var tableView: UITableView {
        let tableView = UITableView()
        tableView.register(DrugCardTableViewCell.self, forCellReuseIdentifier: DrugCardTableViewCell.identifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 170
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.backgroundView = EmptyListView()
        return tableView
    }
    
}
