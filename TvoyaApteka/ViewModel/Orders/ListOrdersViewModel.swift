//
//  ListOrdersViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 02.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ListOrdersViewModel {
    
    // MARK: Input
    
    // MARK: Output
    let isUploading: Driver<Bool>
    let errorMessage = PublishSubject<String>()
    let orders = BehaviorSubject<[Order]>(value: [])
    
    // MARK: Private
    private let user: AuthUserType
    private let repository: OrderRepositoryType
    private let activityIndicator = ActivityIndicator()
    private let errorFabric = ErrorMessageFabric()
    private let bag = DisposeBag()
    
    init(user: AuthUserType, repository: OrderRepositoryType) {
        self.user = user
        self.repository = repository
        self.isUploading = activityIndicator.asDriver()
    }
    
    func uploadOrders() {
        repository.getOrders(for: user, withStatus: nil)
            .trackActivity(activityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] orders in
                self?.orders.onNext(orders)
            }, onError: { [weak self] error in
                self?.handleError(error)
            }).disposed(by: bag)
    }
    
    private func handleError(_ error: Error) {
        if let serviceError = error as? ServiceError {
            switch serviceError {
            case .notFound:
                return
            default:
                showErrorMessage(error)
            }
        }
    }
    
    private func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
}
