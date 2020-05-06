//
//  DrugDescriptionPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class DrugDescriptionViewController: UIViewController {
    
    private let webView = WKWebView()
    private let html: String
    
    init(html: String) {
        self.html = html
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Описание"
        
        setupLauout()
        
        webView.scrollView.maximumZoomScale = 1.0
        webView.scrollView.minimumZoomScale = 1.0
        
        let text = addStyle(to: html)
        webView.loadHTMLString(text, baseURL: nil)
    }
    
    private func setupLauout() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addStyle(to html: String) -> String {
        return """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
        
        body {
        font-family: 'Roboto-Regular', 'Roboto';
        font-size: 100%;
        }
        
        table {
        border-collapse: collapse;
        width: 100%;
        margin-bottom: 1rem;
        border-radius: .15rem;
        }
        
        tbody, tfoot, thead {
        border: 1px solid #f2f2f2;
        background-color: #fff;
        }
        
        tbody tr:nth-child(2n) {
        border-bottom: 0;
        background-color: #f2f2f2;
        }
        
        tbody td, tbody th {
        padding: .5rem .625rem .625rem;
        }
        
        .instruction-title {
        font-weight: bold;
        }
        
        </style>
        </head>
        <body>
        \(html)
        </body>
        </html>
        """
    }
}
