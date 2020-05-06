//
//  UITableView+Rx.swift
//  TvoyaApteka
//
//  Created by BuidMac on 20.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    
    var bottonRefresingIsVisible: Binder<Bool> {
        return Binder<Bool>.init(self.base, binding: { tableView, isVisible in
            if isVisible {
                let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44)
                tableView.tableFooterView = spinner
            } else {
                tableView.tableFooterView = nil
            }
        })
    }
    
}
