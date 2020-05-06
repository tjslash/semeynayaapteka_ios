//
//  OrderSuccessPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 16.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

protocol OrderSuccessViewControllerDelegate: BaseViewControllerDelegate {
    func emptyList()
}

class OrderSuccessViewController: BaseViewController {
    
    public weak var delegate: OrderSuccessViewControllerDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(OrderDetailCardСell.self, forCellReuseIdentifier: OrderDetailCardСell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 200
        tableView.sectionFooterHeight = 70
        tableView.estimatedSectionFooterHeight = 70
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private var cellModels: [OrderDetailsCellModel] = [] {
        didSet {
            orderNums = cellModels.map({ $0.order.id })
            tableView.reloadData()
        }
    }
    
    private var orderNums: [Int] = []
    private let viewModel: OrderSuccessViewModel
    private let bag = DisposeBag()
    
    init(viewModel: OrderSuccessViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = UIColor.taAlmostWhite
        title = "Заказ оформлен"
        addSearchBarButton()
        binding()
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    private func binding() {
        viewModel.cellModels
            .asDriver()
            .drive(onNext: { [unowned self] cellModels in
                self.cellModels = cellModels
                
                if cellModels.isEmpty {
                    self.delegate?.emptyList()
                }
            })
            .disposed(by: bag)
    }
    
}

extension OrderSuccessViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as OrderDetailCardСell
        cell.viewModel = cellModels[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return OrderSuccessHeader(orderNums: orderNums, date: Date())
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = CancelOrderView()

        view.cancelHandler = { [unowned self] in
            self.viewModel.cancelOrder(index: section)
        }
        return view
    }
    
}

private class OrderSuccessHeader: UIView {
    
    private let logoView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "checked"))
        imageView.tintColor = UIColor.taPrimary
        return imageView
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel(text: "Все готово!")
        label.font = UIFont.Title.h2Bold
        label.textColor = UIColor.taPrimary
        label.textAlignment = .center
        return label
    }()
    
    private let orderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel(text: "Ожидайте СМС-оповещение о готовности.\nПримерное время ожидания 10 минут.")
        label.numberOfLines = 0
        return label
    }()
    
    init(orderNums: [Int], date: Date) {
        super.init(frame: .zero)
        setupLayout()
        let startTitleString = orderNums.count > 1 ? "Ваши заказы" : "Ваш заказ"
        let endTitleString = orderNums.count > 1 ? "оформлены" : "оформлен"
        let ordersNumString = orderNums.map({ String($0) }).joined(separator: ", ")
        let ordersDateString = date.toString(format: "dd.MM.YYYY")
        orderLabel.text = "\(startTitleString) №\(ordersNumString) от \(ordersDateString) успешно \(endTitleString)."
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let logoStackView = UIStackView(arrangedSubviews: [logoView, titleLable])
        logoStackView.axis = .vertical
        logoStackView.alignment = .center
        logoStackView.spacing = 15
        
        let mainStackView = UIStackView(arrangedSubviews: [logoStackView, orderLabel, infoLabel])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        
        addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.width.equalTo(77)
        }
    
    }
    
}
