//
//  StoresPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 10.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import Parchment
import RxSwift

protocol DrugStoresViewControllerDelegate: BaseViewControllerDelegate {
    func userSelect(store: DrugStore)
}

class DrugStoresViewController: BaseViewController {
    
    public weak var delegate: DrugStoresViewControllerDelegate?
    
    private var stores: [DrugStore] = [] {
        didSet {
            let controllerArray = createViewControllers(stores: stores)
            setupPaginViewController(with: controllerArray)
        }
    }
    
    private var pagingViewController: FixedPagingViewController!
    private let viewModel: DrugStoresViewModel
    private let bag = DisposeBag()
    
    init(viewModel: DrugStoresViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Адреса аптек"
        view.backgroundColor = UIColor.taAlmostWhite
        addSearchBarButton()
        binding()
        viewModel.uploadStores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopUpdatingLocation()
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    private func binding() {
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.isUploading
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.stores
            .bind(onNext: { [ unowned self] stores in
                self.stores = stores
            })
            .disposed(by: bag)
    }
    
    private func createViewControllers(stores: [DrugStore]) -> [UIViewController] {
        var controllerArray: [UIViewController] = []
        
         // Not setup title directly on the page, otherwise it does not work, setup title is here mast have is here
        
        let map = DrugStoresOnMapViewController(stores: stores)
        map.title = "На карте".uppercased()
        controllerArray.append(map)
        
        let listStores = ListStoresViewController(stores: stores)
        listStores.delegate = self
        listStores.title = "Ближайшие аптеки".uppercased()
        controllerArray.append(listStores)
        
        return controllerArray
    }
    
    private func setupPaginViewController(with controllers: [UIViewController]) {
        pagingViewController = FixedPagingViewController(viewControllers: controllers)
        addPaginView()
        applyStyle()
    }
    
    private func addPaginView() {
        addChildViewController(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParentViewController: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        pagingViewController.view.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    private func applyStyle() {
        pagingViewController.menuInteraction = .none
        pagingViewController.contentInteraction = .none
        pagingViewController.selectedTextColor = UIColor.white
        pagingViewController.textColor = UIColor.white.withAlphaComponent(0.4)
        pagingViewController.menuBackgroundColor = UIColor.taPrimary
        pagingViewController.backgroundColor = UIColor.taPrimary
        pagingViewController.selectedBackgroundColor = UIColor.taPrimary
        pagingViewController.indicatorColor = UIColor.white
        pagingViewController.view.backgroundColor = UIColor.taAlmostWhite
    }
    
}

// MARK: ListStoresPageDelegate
extension DrugStoresViewController: ListStoresViewControllerDelegate {
    
    func userSelect(store: DrugStore) {
        delegate?.userSelect(store: store)
    }
    
}
