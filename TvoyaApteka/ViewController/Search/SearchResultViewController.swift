//
//  SearchViewController.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 21/05/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultViewController: UIViewController {
    
    private let tableView = UITableView.tableView
    private unowned var searchBar: UISearchBar
    private let viewModel: SearchResultViewModel
    private let bag = DisposeBag()
    
    private var isFiltering: Bool {
        return !searchBarIsEmpty
    }
    
    private var searchBarIsEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    private var searchHistory: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var filteredSearchHistory = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(viewModel: SearchResultViewModel, searchBar: UISearchBar) {
        self.viewModel = viewModel
        self.searchBar = searchBar
        super.init(nibName: nil, bundle: nil)
        binding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .taAlmostWhite
        super.viewDidLoad()
        setupLayout()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func binding() {
        inputBinding()
        outputBinding()
    }
    
    private func inputBinding() {
        searchBar.rx.text
            .orEmpty
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchBarText)
            .disposed(by: bag)
        
        searchBar.rx.searchButtonClicked
            .bind(to: viewModel.searchButtonDidTap)
            .disposed(by: bag)
    }
    
    private func outputBinding() {
        viewModel.searchErrorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.suggestions
            .bind(onNext: { [unowned self] suggestions in
                self.filteredSearchHistory = suggestions
            })
            .disposed(by: bag)
        
        viewModel.searchHistory
            .bind(onNext: { [unowned self] searchHistory in
                self.searchHistory = searchHistory
            })
            .disposed(by: bag)
        
        viewModel.searchResultIsEmpty
            .bind(onNext: { [unowned self] _ in
                self.showEmptySearchResultAlert()
            })
            .disposed(by: bag)
    }

    private func showEmptySearchResultAlert() {
        let alert = UIAlertController(title: nil, message: "Ничего не найдено, попробуйте еще раз.", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(doneAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredSearchHistory.count
        }
        return searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as UITableViewCell
        let item: String
        
        if isFiltering {
            item = filteredSearchHistory[indexPath.row]
        } else {
            item = searchHistory[indexPath.row]
        }
        
        cell.textLabel!.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let searchText = tableView.cellForRow(at: indexPath)?.textLabel?.text
        viewModel.performSearch(text: searchText!)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering {
            return "Возможно вы искали:"
        }
        return nil
    }
}

// MARK: Static UITableView fabric
private extension UITableView {
    
    static var tableView: UITableView {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.rowHeight = 40
        tableView.estimatedRowHeight = 40
        tableView.backgroundColor = .clear
        return tableView
    }
    
}
