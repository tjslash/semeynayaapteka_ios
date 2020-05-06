//
//  PreloaderPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 18.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

class PreloaderViewController: BaseViewController {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.activityIndicatorViewStyle = .gray
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
