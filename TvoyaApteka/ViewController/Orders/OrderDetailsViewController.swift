//
//  OrderDetailsPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

protocol ListOrdersViewControllerBackDelegate: BaseViewControllerDelegate {
    func deleted(order: Order)
    func didSelect(item: Drug)
}

class OrderDetailsViewController: ScrollViewController {
  
    private var orderDetailView = OrderDetailCardView()
    private var drugTableView = OrdersDrugTableView(frame: .zero, style: .grouped)

    private let viewModel: OrderDetailsViewModel
    private let bag = DisposeBag()
    
    public weak var delegate: ListOrdersViewControllerBackDelegate?

    init(viewModel: OrderDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.taAlmostWhite
        title = "Просмотр заказа"
        scrollView.bounces = false
        addSearchBarButton()
        binding()
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    override func setupLayout() {
        super.setupLayout()
        let wrapperOrderDetailView = UIView()
        wrapperOrderDetailView.backgroundColor = UIColor.taPrimary
        
        contentView.addSubview(wrapperOrderDetailView)
        wrapperOrderDetailView.addSubview(orderDetailView)
        contentView.addSubview(drugTableView)

        wrapperOrderDetailView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        orderDetailView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        drugTableView.snp.makeConstraints { make in
            make.top.equalTo(wrapperOrderDetailView.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(drugTableView.contentSize.height)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        drugTableView.snp.updateConstraints { make in
            make.height.equalTo(drugTableView.contentSize.height +
                drugTableView.sectionFooterHeight +
                drugTableView.sectionHeaderHeight)
        }
    }
    
    private func binding() {
        viewModel.isLoading
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.cancelOrderIsSuccess
            .bind(onNext: { [unowned self] order in
                self.delegate?.deleted(order: order)
            })
            .disposed(by: bag)
        
        viewModel.order
            .drive(onNext: { [unowned self] order in
                self.updateUI(order: order)
            })
            .disposed(by: bag)
    }
  
    func updateUI(order: Order) {
        orderDetailView.viewModel = OrderDetailsCellModel(order: order)
        drugTableView.cellModels = order.drugs.map({ DrugOrderCellModel(drug: $0) })
        drugTableView.orderCanBeCanceled = order.state == .inProgress
        updateViewConstraints()
        
        drugTableView.cancelOrder = { [unowned self] in
            self.viewModel.cancelOrder(order)
        }
        
        drugTableView.didSelect = { [unowned self]  drugCard in
            self.delegate?.didSelect(item: drugCard)
        }
    }
}
