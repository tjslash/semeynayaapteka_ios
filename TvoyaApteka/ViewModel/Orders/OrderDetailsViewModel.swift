//
//  OrderDetailsViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 02.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class OrderDetailsViewModel {
    
    // MARK: Input
    
    // MARK: Output
    let isLoading: Driver<Bool>
    let errorMessage = PublishSubject<String>()
    let cancelOrderIsSuccess = PublishSubject<Order>()
    let order: Driver<Order>
    
    // MARK: Private
    private let orderId: Int
    private let user: AuthUserType
    private let repository: OrderRepositoryType
    private let orderResuls = PublishSubject<Order?>()
    private let activityIndicator = ActivityIndicator()
    private let errorFabric = ErrorMessageFabric()
    private let bag = DisposeBag()
    
    init(user: AuthUserType, orderId: Int, repository: OrderRepositoryType) {
        self.user = user
        self.orderId = orderId
        self.repository = repository
        
        self.isLoading = activityIndicator.asDriver()
        
        self.order = orderResuls
            .asDriver(onErrorJustReturn: nil)
            .filter({ $0 != nil})
            .map({ $0! })
        
        uploadOrder()
    }
    
    func cancelOrder(_ order: Order) {
        repository.cancelOrder(id: order.id, for: user)
            .trackActivity(activityIndicator)
            .asCompletable()
            .subscribe(onCompleted: { [weak self] in
                self?.cancelOrderIsSuccess.onNext(order)
            }, onError: { [weak self] error in
                self?.showErrorMessage(error)
            }).disposed(by: self.bag)
    }
    
    private func uploadOrder() {
        repository.getOrder(id: orderId, for: user)
            .trackActivity(activityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] order in
                self?.orderResuls.onNext(order)
            }, onError: { [weak self] error in
                self?.showErrorMessage(error)
            })
            .disposed(by: bag)
    }
    
    private func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
}
