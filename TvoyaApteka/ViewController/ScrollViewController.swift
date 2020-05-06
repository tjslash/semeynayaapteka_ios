//
//  ScrollViewController.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

class ScrollViewController: BaseViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    open func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview().priority(.low)
            make.width.equalTo(view)
        }
    }
    
}

extension ScrollViewController {
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let frame = ((userInfo[UIKeyboardFrameEndUserInfoKey]) as? NSValue)?.cgRectValue else {
            return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
    }
    
}
