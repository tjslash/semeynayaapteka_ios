//
//  NotConnectionViewController.swift
//  TvoyaApteka
//
//  Created by BuidMac on 31.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import Reachability

class NotConnectionViewController: UIViewController {

    // MARK: View property
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h2Bold
        label.textColor = .taBlack
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h3
        label.textColor = .taGray
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Private property
    
    private let reachability = Reachability()!
    private let reconectCallback: () -> Void
    
    // MARK: Init
    
    init(reconectCallback: @escaping () -> Void) {
        self.reconectCallback = reconectCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Other
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.taAlmostWhite
        setupLayout()
        setupUI()
        setupReconectHandler()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    private func setupLayout() {
        let contentView = UIView()
        
        view.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(300)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(94)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(44)
            make.left.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupUI() {
        imageView.image = #imageLiteral(resourceName: "NotConnectionIcon")
        titleLabel.text = "Нет подключения к Интернету"
        descriptionLabel.text = "Проверьте подключение к мобильному интернету или сети Wi-Fi"
    }
    
    private func setupReconectHandler() {
        reachability.whenReachable = { [unowned self] reachability in
            self.reconectCallback()
            self.remove()
        }
    }
    
    deinit {
        print("Deinit: \(self)")
    }
    
}
