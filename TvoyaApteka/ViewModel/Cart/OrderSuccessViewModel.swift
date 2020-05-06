//
//  OrderSuccessViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class OrderSuccessViewModel {
    
    // MARK: Output
    let cellModels: Variable<[OrderDetailsCellModel]>
    let errorMessage = PublishSubject<Error>()
    
    // MARK: Private
    private let user: AuthUserType
    private let repository: OrderRepositoryType
    private let bag = DisposeBag()
    
    init(user: AuthUserType, orders: [Order], repository: OrderRepositoryType) {
        self.user = user
        self.repository = repository
        self.cellModels = Variable<[OrderDetailsCellModel]>(orders.map({ OrderDetailsCellModel(order: $0) }))
    }
    
    func cancelOrder(index: Int) {
        guard index < cellModels.value.count else { return }
        let orderId = cellModels.value[index].order.id
        
        repository.cancelOrder(id: orderId, for: user)
            .subscribe(onCompleted: { [unowned self] in
                    self.cellModels.value.remove(at: index)
                }, onError: { [unowned self] error in
                    self.errorMessage.onNext(error)
            })
            .disposed(by: bag)
    }
    
}
