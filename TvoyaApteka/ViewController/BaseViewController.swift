//
//  BaseViewController.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 15/05/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

protocol BaseViewControllerDelegate: class {
    func didSelectSearch()
}

class BaseViewController: UIViewController, HandleErrorProtocol {
    
    private lazy var preloader = PreloaderViewController()
    private let errorFabric = ErrorMessageFabric()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    func handleError(_ error: Error) {
        if let message = errorFabric.getMessage(form: error) {
            ErrorPresenter.showError(text: message)
        }
    }
    
    public func showPreloader() {
        add(preloader)
    }
    
    public func hidePreloader() {
        preloader.remove()
    }
    
    deinit {
        print("Page: deinit \(self)")
    }
    
}

// MARK: - UIBarButtonItem extension
extension BaseViewController {
    
    func addSearchBarButton() {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "Search"), style: .plain, target: self, action: #selector(searchButtonHandler))
        addAsFirstItem(item: button)
    }
    
    func addFilterBarButton() {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "Filter"), style: .plain, target: self, action: #selector(filterButtonHandler))
        addAsFirstItem(item: button)
    }
    
    func addAsFirstItem(item: UIBarButtonItem) {
        if var items = navigationItem.rightBarButtonItems {
            items.insert(item, at: 0)
            navigationItem.rightBarButtonItems = items
        } else {
            navigationItem.rightBarButtonItems = [item]
        }
    }
    
    @objc
    func searchButtonHandler() {
   
    }
    
    @objc
    func filterButtonHandler() {
        
    }
    
}
