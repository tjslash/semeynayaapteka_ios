//
//  ManufacturerPage.swift
//  TvoyaApteka
//
//  Created by oleg shkreba on 24.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

protocol ManufacturerViewControllerDelegate: class {
    func setManufacturersIds(ids: Set<Int>)
}

class ManufacturerViewController: BaseViewController {
    
    private let tableView = UITableView.tableView
    
    private var manufacturers: [Manufacturer] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var selectedManufacturers: Set<Int>
    
    private func addManufacturer(manufacturer: Manufacturer) {
        selectedManufacturers.insert(manufacturer.id)
        delegate?.setManufacturersIds(ids: selectedManufacturers)
    }
    
    private func removeManufacturer(manufacturer: Manufacturer) {
        selectedManufacturers.remove(manufacturer.id)
        delegate?.setManufacturersIds(ids: selectedManufacturers)
    }
    
    private let bag = DisposeBag()
    weak var delegate: ManufacturerViewControllerDelegate?
    private let drugRepository: DrugRepositoryType
    
    init(drugRepository: DrugRepositoryType, selected selectedId: Set<Int>) {
        self.drugRepository = drugRepository
        self.selectedManufacturers = selectedId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        setupLayout()
        title = "Производитель"
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if manufacturers.isEmpty {
            uploadManufacturers()
        }
    }
    
    func uploadManufacturers() {
        showPreloader()
        
        drugRepository.getManufacturersAndPrices()
            .subscribe(onSuccess: { [weak self] manufacturersAndPrice in
                self?.manufacturers = manufacturersAndPrice.manufacturers
                self?.hidePreloader()
            }).disposed(by: bag)
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
extension ManufacturerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = (manufacturers.count != 0)
        return manufacturers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as UITableViewCell
        let manufacturer = manufacturers[indexPath.row]
        
        cell.textLabel?.text = manufacturer.title
        cell.accessoryType = .none
        cell.tintColor = .taPrimary
        cell.backgroundColor = .clear
        
        if selectedManufacturers.contains(manufacturer.id) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard manufacturers.indices.contains(indexPath.row) else { return }
        let manufacturer = manufacturers[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                removeManufacturer(manufacturer: manufacturer)
            } else {
                cell.accessoryType = .checkmark
                addManufacturer(manufacturer: manufacturer)
            }
        }
    }
}

// MARK: Static UITableView fabric
private extension UITableView {
    
    static  var tableView: UITableView {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.rowHeight = Const.tableViewRowHeight
        tableView.estimatedRowHeight = Const.tableViewRowHeight
        tableView.backgroundColor = .clear
        tableView.backgroundView = EmptyListView()
        return tableView
    }
    
}
