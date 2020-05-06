//
//  ListDealsPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 19.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

protocol ListDealsViewControllerDelegate: BaseViewControllerDelegate {
    func selectDeal(id: Int)
}

class ListDealsViewController: BaseViewController {
    
    public weak var delegate: ListDealsViewControllerDelegate?
    
    private let tableView = UITableView.tableView
    private let refreshControll = UIRefreshControl()
    private let bag = DisposeBag()
    private let viewModel: ListDealsViewModel
    
    private var cellViewModels: [DealCellModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(viewModel: ListDealsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = UIColor.taAlmostWhite
        title = "Акции"
        addSearchBarButton()
        setupTableView()
        binding()
        viewModel.uploadPromo()
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
    
    private func binding() {
        viewModel.isUploading
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.cellModels
            .asDriver()
            .drive(onNext: { [unowned self] models in
                self.cellViewModels = models
            })
            .disposed(by: bag)
        
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        refreshControll.rx.controlEvent(.valueChanged)
            .bind(onNext: { [unowned self] in 
                self.viewModel.refreshDeals()
            })
            .disposed(by: bag)
        
        viewModel.isRefreshing
            .drive(refreshControll.rx.isRefreshing)
            .disposed(by: bag)
        
        viewModel.isLoadingMore
            .drive(tableView.rx.bottonRefresingIsVisible)
            .disposed(by: bag)
    }
    
}

// MARK: - UITableView
extension ListDealsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            viewModel.loadMore()
        }
    }
    
}

// MARK: UITableView
extension ListDealsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = (cellViewModels.count != 0)
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as DealCell
        cell.viewModel = cellViewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.selectDeal(id: cellViewModels[indexPath.row].promotion.id)
    }
    
}

// MARK: Static UITableView fabric
private extension UITableView {
    
    static var tableView: UITableView {
        let tableView = UITableView()
        tableView.register(DealCell.self, forCellReuseIdentifier: DealCell.identifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.backgroundView = EmptyListView()
        return tableView
    }
    
}
