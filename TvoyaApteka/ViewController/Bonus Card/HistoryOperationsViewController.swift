//
//  HistoryOperationsPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 18.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class HistoryOperationsViewController: BaseViewController {
  
    private let bag = DisposeBag()
    private let bonusCardRepository: BonusCardRepositoryType = BonusCardRepository()
    private let user: AuthUserType
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OperationsCell.self, forCellReuseIdentifier: OperationsCell.identifier)
        tableView.register(OperationsHeader.self, forHeaderFooterViewReuseIdentifier: OperationsHeader.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 66
        tableView.estimatedRowHeight = 66
        tableView.sectionHeaderHeight = 44
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.backgroundView = EmptyListView()
        return tableView
    }()
    
    private struct HistoryItems {
        let date: Date
        let listOperation: [BonusOperation]
    }
    
    private var histotyList: [HistoryItems] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: BaseViewControllerDelegate?
    
    init(user: AuthUserType) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBarButton()
        view.backgroundColor = .taAlmostWhite
        title = "История операций"
        setupLayout()
        showPreloader()
        uploadHistoryOperations()
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
    
    private func uploadHistoryOperations() {
        bonusCardRepository.getBonusCard(for: user)
            .subscribe(onSuccess: { [unowned self] bonusCard in
                self.hidePreloader()
                let groupedOperations = self.groupByDate(operations: bonusCard.operations)
                let objects = self.convertToHistoryItems(from: groupedOperations)
                self.histotyList = objects
            }, onError: { error in
                self.hidePreloader()
                print("Error: \(error)")
            }).disposed(by: bag)
    }
    
    private func groupByDate(operations: [BonusOperation]) -> [Date: [BonusOperation]] {
        var result: [Date: [BonusOperation]] = [:]

        for operation in operations {
            let roundedDate = Calendar.current.startOfDay(for: operation.date)
                
            if result[roundedDate] == nil {
                result[roundedDate] = []
            }
            
            result[roundedDate]?.append(operation)
        }
        
        return result
    }
    
    private func convertToHistoryItems(from dictionary: [Date: [BonusOperation]]) -> [HistoryItems] {
        var objectArray: [HistoryItems] = []
        
        for (key, value) in dictionary {
            objectArray.append(HistoryItems(date: key, listOperation: value))
        }
        
        return objectArray
    }
    
}

// MARK: UITableView
extension HistoryOperationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView?.isHidden = (histotyList.count != 0)
        tableView.separatorStyle = (histotyList.count != 0) ? .singleLine : .none
        return histotyList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histotyList[section].listOperation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as OperationsCell
        let item = histotyList[indexPath.section].listOperation[indexPath.row]
        cell.configure(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView() as OperationsHeader
        cell.text = histotyList[section].date.toString(format: Const.DateFormat.bonusHistoryHeader)
        cell.contentView.backgroundColor = .taAlmostWhite
        return cell
    }
    
}
