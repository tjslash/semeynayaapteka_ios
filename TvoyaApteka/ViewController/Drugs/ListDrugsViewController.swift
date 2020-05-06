//
//  ListDrugsPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 24.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Kingfisher

protocol ListDrugsViewControllerDelegate: BaseViewControllerDelegate {
    func authorizationRequired()
    func didSelected(drug: Drug)
    func didSelectFilter()
}

class ListDrugsViewController: BaseViewController {
    
    private var cellModels: [DrugCellModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView = UITableView.tableView
    private let refreshControll = UIRefreshControl()
    private let countPickerViewPresenter: UIView & CountPickerViewPresenterType
    let viewModel: ListDrugsViewModel
    private let bag = DisposeBag()
    
    public weak var delegate: ListDrugsViewControllerDelegate?
    
    init(viewModel: ListDrugsViewModel) {
        self.viewModel = viewModel
        self.countPickerViewPresenter = CountPickerViewPresenter()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = UIColor.taAlmostWhite
        addSearchBarButton()
        addFilterBarButton()
        setupTableView()
        binding()
        viewModel.firstUploadDrugs()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControll
        } else {
            tableView.addSubview(refreshControll)
        }
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(countPickerViewPresenter)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }

    private func binding() {
        bindingInput()
        bindingOutput()
    }
    
    private func bindingInput() {
        refreshControll.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshData)
            .disposed(by: bag)
        
        viewModel.showRecipeAlert = { [unowned self] doneHandler in
            self.showPrescriptionDrugAlert(completion: doneHandler)
        }
        
        viewModel.showCount = { [unowned self] min, max, successHandler in
            self.countPickerViewPresenter.showKeyboard(min: min, max: max, doneHandler: successHandler)
        }
        
        viewModel.notAuthorization = { [unowned self] in
            self.delegate?.authorizationRequired()
        }
    }
    
    private func bindingOutput() {
        viewModel.cellModels
            .asDriver()
            .drive(onNext: { [unowned self] models in
                self.cellModels = models
            })
            .disposed(by: bag)
        
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.isUploading
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.isRefreshing
            .drive(refreshControll.rx.isRefreshing)
            .disposed(by: bag)
        
        viewModel.isLoadingMore
            .drive(tableView.rx.bottonRefresingIsVisible)
            .disposed(by: bag)
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    override func filterButtonHandler() {
        delegate?.didSelectFilter()
    }
    
}

// MARK: - UITableView
extension ListDrugsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        if deltaOffset <= 0 {
            viewModel.loadMore()
        }
    }
    
}

// MARK: - UITableView
extension ListDrugsViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.didSelected(drug: cellModels[indexPath.row].drug)
    }
}

// MARK: Static UITableView fabric
private extension UITableView {
    
    static var tableView: UITableView {
        let tableView = UITableView()
        tableView.register(DrugCardTableViewCell.self, forCellReuseIdentifier: DrugCardTableViewCell.identifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 165
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.backgroundView = EmptyListView()
        return tableView
    }
    
}
