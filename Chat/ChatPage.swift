//
//  ChatPage.swift
//  Chat
//
//  Created by BuidMac on 09.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import WebKit

public class ChatPage: UIViewController {
    
    private let webView = UIWebView()
    
    private lazy var jivoSdk: JivoSdk = {
        let jivo = JivoSdk.init(webView, "ru")!
        jivo.delegate = self
        return jivo
    }()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        jivoSdk.start()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        jivoSdk.stop()
    }
    
    private func setupView() {
        webView.backgroundColor = .white
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: webView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0
            ),
            NSLayoutConstraint(item: webView,
                               attribute: .left,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .left,
                               multiplier: 1.0,
                               constant: 0
            ),
            NSLayoutConstraint(item: webView,
                               attribute: .right,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .right,
                               multiplier: 1.0,
                               constant: 0
            ),
            NSLayoutConstraint(item: webView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: -50
            )
        ])
        webView.delegate = jivoSdk
        title = "Чат"
    }
    
}

extension ChatPage: JivoDelegate {
    
    public func onEvent(_ name: String!, _ data: String!) {
        print("Test delegate with \(name) and \(data)")
    }
    
}
