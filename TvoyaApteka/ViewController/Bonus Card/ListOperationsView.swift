//
//  ListOperationsView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 18.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class ListOperationsView: UIView {
    
    public var showAllHistory: (() -> Void)?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(OperationsCell.self, forCellReuseIdentifier: OperationsCell.identifier)
        tableView.register(OperationsHeader.self, forHeaderFooterViewReuseIdentifier: OperationsHeader.identifier)
        tableView.register(OperationsFooter.self, forHeaderFooterViewReuseIdentifier: OperationsFooter.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 66
        tableView.estimatedRowHeight = 66
        tableView.sectionFooterHeight = 60
        tableView.sectionHeaderHeight = 40
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    public var operations: [BonusOperation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(tableView.contentSize.height + tableView.sectionFooterHeight + 10)
        }
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        tableView.snp.updateConstraints { make in
            make.height.equalTo(tableView.contentSize.height + tableView.sectionFooterHeight + 10)
        }
    }
    
}

// MARK: UITableView
extension ListOperationsView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as OperationsCell
        let item = operations[indexPath.row]
        cell.configure(item: item)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = OperationsFooter()
        view.text = "Показать всю историю"
        view.buttonTap = { [weak self] in self?.showAllHistory?() }
        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView() as OperationsHeader
        cell.text = "Последние операции".uppercased()
        return cell
    }
    
}

public class OperationsCell: UITableViewCell {
    
    public var dateText: String? {
        didSet {
            dateLabel.text = dateText
        }
    }
    
    public enum OperationType {
        case plus, minus
    }
    
    public var typeOperation: OperationType = .plus {
        didSet {
            switch typeOperation {
            case .plus:
                nameLabel.text = "Начислено"
                iconView.image = #imageLiteral(resourceName: "plus")
                iconView.tintColor = UIColor.taPrimary
            case .minus:
                nameLabel.text = "Потрачено"
                iconView.image = #imageLiteral(resourceName: "minus")
                iconView.tintColor = UIColor.taRed
            }
        }
    }
    
    public var resultText: String? {
        didSet {
            resultLabel.text = resultText
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h3
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h5
        label.textColor = UIColor.taGray
        return label
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        return iv
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.Title.h3
        label.textColor = UIColor.taGray
        return label
    }()
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let operationView = UIView()
        contentView.addSubview(operationView)
        operationView.addSubview(nameLabel)
        operationView.addSubview(dateLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(resultLabel)
        
        operationView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.right.equalTo(iconView.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }
    
}

// MARK: PayHistoryItem configurator
extension OperationsCell {
    
    func configure(item: BonusOperation) {
        self.dateText = item.date.toString(withFormat: .dateText)
        self.resultText = "\(abs(item.amount)) \(Int(item.amount).pluralForm(form1: "бонус", form2: "бонуса", form5: "бонусов"))"
        self.typeOperation = item.amount < 0 ? .minus : .plus
    }
    
}

public class OperationsHeader: UITableViewHeaderFooterView {
    
    public var text: String? {
        didSet {
            titleLabel.text = text
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
        backgroundColor = .clear
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
}

private class OperationsFooter: UITableViewHeaderFooterView {
    
    public var text: String? {
        didSet {
            button.setTitle(text, for: .normal)
        }
    }
    
    public var buttonTap: (() -> Void)?
    
    private let button: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.taPrimary, for: .normal)
        return btn
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
        backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonTapHandler), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(button)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc
    private func buttonTapHandler() {
        buttonTap?()
    }
    
}
