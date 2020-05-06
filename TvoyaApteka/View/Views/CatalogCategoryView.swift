//
//  CatalogCategoryView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class CatalogCategoryView: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogCategoryCell.self, forCellReuseIdentifier: CatalogCategoryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 88
        tableView.estimatedRowHeight = 88
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    public var didSelectItem: ((_ row: Int) -> Void)?
    
    public var categoryItems: [CategoryItem] {
        didSet {
            tableView.reloadData()
            updateConstraints()
        }
    }
    
    public init(items: [CategoryItem]) {
        self.categoryItems = items
        super.init(frame: .zero)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(tableView.contentSize.height + 10)
        }
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        tableView.snp.updateConstraints { make in
            make.height.equalTo(tableView.contentSize.height + 10)
        }
    }
    
}

// MARK: UITableView
extension CatalogCategoryView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CatalogCategoryCell
        cell.titleLabel.text = categoryItems[indexPath.row].title
        cell.iconView.image = categoryItems[indexPath.row].image
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectItem?(indexPath.row)
    }
    
}

public struct CategoryItem {
    public init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
    public let image: UIImage
    public let title: String
}

private class CatalogCategoryCell: TableViewCardCell {
    
    let iconView = UIImageView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.Title.h2
        return label
    }()
    
    override func setupLayout() {
        super.setupLayout()
        bgView.addSubview(iconView)
        bgView.addSubview(titleLabel)
        
        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(30)
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
        }
    }
    
    override func applyStyle() {
        super.applyStyle()
        titleLabel.textColor = .taPrimary
        iconView.tintColor = .taPrimary
    }
    
    override func applyHighlightedStyle() {
        super.applyHighlightedStyle()
        titleLabel.textColor = .white
        bgView.backgroundColor = .taPrimary
        iconView.tintColor = .white
        bgView.layer.shadowColor = UIColor.taPrimary.cgColor
    }
    
}
