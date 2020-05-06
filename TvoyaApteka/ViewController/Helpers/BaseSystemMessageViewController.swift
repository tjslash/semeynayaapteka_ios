//
//  BaseSystemMessagePage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 18.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

class BaseSystemMessageViewController: BaseViewController {
    
    let contentView = UIView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupStype()
        
    }
    
    private func setupStype() {
        contentView.backgroundColor = .taAlmostWhite
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        contentView.layer.cornerRadius = 5
    }
    
    func setupLayout() {
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
        }
    }
    
}
