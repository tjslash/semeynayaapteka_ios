//
//  CitiesPage.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 16.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ListCitiesViewModelType {
    // MARK: Input
    var showWarningAlert: ((_ cancelHandler: @escaping () -> Void, _ doneHandler: @escaping () -> Void) -> Void)? { get set }
    
    // MARK: Output
    var cities: BehaviorSubject<[City]> { get }
    var isUploading: Driver<Bool> { get }
    var errorMessage: PublishSubject<String> { get }
    
    func didSelect(city: City)
}

class ListCitiesViewController: BaseSelectListController {
    
    private var cities: [City] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var viewModel: ListCitiesViewModelType
    private let bag = DisposeBag()
    
    init(viewModel: ListCitiesViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Выберите свой город"
        binding()
    }
    
    private func binding() {
        viewModel.cities
            .bind(onNext: { [unowned self] cities in
                self.cities = cities
            })
            .disposed(by: bag)
        
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.isUploading
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.showWarningAlert = { [unowned self] cancelHandler, doneHandler in
            self.showClearCartAlert(cancelHandler: { _ in cancelHandler() }, clearHandler: { _ in doneHandler() })
        }
    }
    
    func showClearCartAlert(cancelHandler: ((UIAlertAction) -> Void)?, clearHandler: ((UIAlertAction) -> Void)?) {
        let alertMessage = "Вы уверены, что хотите изменить выбранной город? Ваша корзина будет очищена."
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: cancelHandler)
        let clearAction = UIAlertAction(title: "Продолжить", style: .destructive, handler: clearHandler)
        alert.addAction(cancelAction)
        alert.addAction(clearAction)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: UITableView
extension ListCitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = (cities.count != 0)
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = cities[indexPath.row].title
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelect(city: cities[indexPath.row])
    }
    
}
