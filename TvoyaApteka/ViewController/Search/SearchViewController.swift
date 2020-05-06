//
//  SearchAndResultPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 22.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func authorizationRequired()
    func didSelected(drug: Drug) 
}

class SearchViewController: BaseViewController {
    
    private var searchResultViewController: SearchResultViewController?
    private var searchDrugListViewController: SearchDrugListViewController?
    private let drugRepository: DrugRepositoryType
    private let drugStoreRepository: DrugStoreRepositoryType
    private let cartManager: CartManagerType

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.tintColor = UIColor.black.withAlphaComponent(0.7)
        searchBar.showsCancelButton = false
        return searchBar
    }()
    
    weak var delegate: SearchViewControllerDelegate?
    
    init(drugRepository: DrugRepositoryType, drugStoreRepository: DrugStoreRepositoryType, cartManager: CartManagerType) {
        self.drugRepository = drugRepository
        self.drugStoreRepository = drugStoreRepository
        self.cartManager = cartManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSearchPage()
    }
    
    override func searchButtonHandler() {
        showSearchPage()
    }

    private func showSearchPage() {
        guard self.childViewControllers.contains(where: { $0 is SearchResultViewController}) == false else {
            return
        }
        
        navigationItem.titleView = self.searchBar
        navigationItem.rightBarButtonItems = []
        navigationItem.leftBarButtonItems = []
        searchBar.text = nil
        
        let searchResultViewModel = SearchResultViewModel(drugRepository: drugRepository)
        searchResultViewModel.delegate = self
        searchResultViewController = SearchResultViewController(viewModel: searchResultViewModel, searchBar: searchBar)
        add(searchResultViewController!)
        searchDrugListViewController?.remove()
        
        searchBar.becomeFirstResponder()
    }
    
    private func showResultPage(drugs: [Drug]) {
        guard self.childViewControllers.contains(where: { $0 is SearchDrugListViewController}) == false else {
            return
        }
        
        navigationItem.titleView = nil
        navigationItem.title = "Результат поиска"
        addSearchBarButton()
        
        let searchDrugListViewModel = SearchDrugListViewModel(drugs: drugs,
                                                              cartManager: cartManager,
                                                              drugStoreRepository: drugStoreRepository)
        searchDrugListViewModel.delegate = self
        searchDrugListViewController = SearchDrugListViewController(viewModel: searchDrugListViewModel)
        add(searchDrugListViewController!)
        searchResultViewController?.remove()
    }

}

// MARK: SearchViewModelDelegate
extension SearchViewController: SearchResultViewModelDelegate {
    
    func didFoundResult(drugs: [Drug]) {
        showResultPage(drugs: drugs)
    }
    
}

// MARK: SearchResultsPageDelegate
extension SearchViewController: SearchDrugListViewModelDelegate {
    
    func authorizationRequired() {
        delegate?.authorizationRequired()
    }
    
    func didSelected(drug: Drug) {
        delegate?.didSelected(drug: drug)
    }
    
}
