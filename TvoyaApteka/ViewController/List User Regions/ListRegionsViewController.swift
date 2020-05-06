//
//  RegionsPage.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 16.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift

class ListRegionsViewController: BaseSelectListController {

    private var regions: [Region] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let viewModel: ListRegionsViewModel
    private let bag = DisposeBag()
    
    init(viewModel: ListRegionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Выберите свой регион"
        tableView.delegate = self
        tableView.dataSource = self
        binding()
        viewModel.uploadRegions()
    }

    private func binding() {
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.isUploading
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.regions
            .bind(onNext: { [unowned self] regions in
                self.regions = regions
            })
            .disposed(by: bag)
    }
    
}

// MARK: UITableView
extension ListRegionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = (regions.count != 0)
        return regions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = regions[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = .taPrimary
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelect(region: regions[indexPath.row])
    }
    
}
