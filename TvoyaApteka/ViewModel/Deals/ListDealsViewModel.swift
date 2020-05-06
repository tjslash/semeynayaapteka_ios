//
//  ListDealsViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 02.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ListDealsViewModel {
    
    // MARK: Input
    
    // MARK: Output
    let isUploading: Driver<Bool>
    let isLoadingMore: Driver<Bool>
    let isRefreshing: Driver<Bool>
    let cellModels = Variable<[DealCellModel]>([])
    let errorMessage = PublishSubject<String>()
    
    // MARK: Private
    private let loadAtOnce = 20
    private var loadMoreStatus = false
    private var allCardsLoaded = false
    private let repository: PromoRepositoryType
    private let errorFabric = ErrorMessageFabric()
    private let loadMoreActivityIndicator = ActivityIndicator()
    private let refreshingActivityIndicator = ActivityIndicator()
    private let activityIndicator = ActivityIndicator()
    private let bag = DisposeBag()
    
    private var currentCity: City {
        return AppConfiguration.shared.currentCity!
    }
    
    init(repository: PromoRepositoryType) {
        self.repository = repository
        self.isUploading = activityIndicator.asDriver()
        self.isLoadingMore = loadMoreActivityIndicator.asDriver()
        self.isRefreshing = refreshingActivityIndicator.asDriver()
    }
    
    func uploadPromo() {
        repository.getPromotions(count: loadAtOnce, offset: 0, in: currentCity)
            .trackActivity(activityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] deals in
                guard let strongSelf = self else { return }
                strongSelf.allCardsLoaded = strongSelf.cellModels.value.count < strongSelf.loadAtOnce
                let models = deals.map({ DealCellModel(promotion: $0) })
                strongSelf.cellModels.value = models
            }, onError: { [weak self] error in
                self?.handleError(error)
            })
            .disposed(by: bag)
    }
    
    func loadMore() {
        if loadMoreStatus == false && allCardsLoaded == false {
            self.loadMoreStatus = true
            
            repository.getPromotions(count: loadAtOnce, offset: 0, in: currentCity)
                .trackActivity(refreshingActivityIndicator)
                .asSingle()
                .subscribe(onSuccess: { [weak self] deals in
                    guard let strongSelf = self else { return }
                    strongSelf.allCardsLoaded = strongSelf.cellModels.value.count < strongSelf.loadAtOnce
                    let models = deals.map({ DealCellModel(promotion: $0) })
                    strongSelf.cellModels.value.append(contentsOf: models)
                    self?.loadMoreStatus = false
                    }, onError: { [weak self] error in
                        self?.loadMoreStatus = false
                        self?.handleError(error)
                })
                .disposed(by: bag)
        }
    }
    
    func refreshDeals() {
        repository.getPromotions(count: loadAtOnce, offset: 0, in: currentCity)
            .trackActivity(refreshingActivityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] deals in
                guard let strongSelf = self else { return }
                strongSelf.allCardsLoaded = strongSelf.cellModels.value.count < strongSelf.loadAtOnce
                let models = deals.map({ DealCellModel(promotion: $0) })
                strongSelf.cellModels.value = models
                }, onError: { [weak self] error in
                    self?.handleError(error)
            })
            .disposed(by: bag)
    }
    
    private func handleError(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
}
