//
//  ListStoresPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 10.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

protocol ListStoresViewControllerDelegate: class {
    func userSelect(store: DrugStore)
}

class ListStoresViewController: BaseViewController {
    
    public weak var delegate: ListStoresViewControllerDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(DrugStoreCell.self, forCellReuseIdentifier: DrugStoreCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0)
        tableView.estimatedRowHeight = 165
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.backgroundView = EmptyListView()
        return tableView
    }()
    
    private var cellModels: [DrugStoreCellModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let locationManager = CLLocationManager()
    
    init(stores: [DrugStore]) {
        super.init(nibName: nil, bundle: nil)
        self.cellModels = stores.map({ DrugStoreCellModel(drugStore: $0) })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        setupLayout()
        showPreloader()
        locationManager.delegate = self
        locationManager.requestLocation()
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
extension ListStoresViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        delegate?.userSelect(store: cellModels[indexPath.row].drugStore)
    }
    
}

// MARK: CLLocationManagerDelegate
extension ListStoresViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        
        self.cellModels = cellModels.sorted(by: currentLocation, predicate: { $0 < $1 })
        hidePreloader()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
        hidePreloader()
    }
    
}

extension Array where Element == DrugStoreCellModel {
    
    func sorted(by location: CLLocation, predicate: (CLLocationDistance, CLLocationDistance) -> Bool) -> [DrugStoreCellModel] {
        return self.sorted { (model1, model2) -> Bool in
            let store1Location = CLLocation(latitude: Double(model1.drugStore.latitude)!, longitude: Double(model1.drugStore.longitude)!)
            let store2Location = CLLocation(latitude: Double(model2.drugStore.latitude)!, longitude: Double(model2.drugStore.longitude)!)
            let store1Distance = location.distance(from: store1Location)
            let store2Distance = location.distance(from: store2Location)
            return predicate(store1Distance, store2Distance)
        }
    }
    
}
