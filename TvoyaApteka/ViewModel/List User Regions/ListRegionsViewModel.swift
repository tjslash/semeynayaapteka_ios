//
//  ListRegionsViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 03.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ListRegionsViewModelDelegate: class {
    func userSelectRegion(with cities: [City])
}

class ListRegionsViewModel {
    
    // MARK: Output
    let regions = PublishSubject<[Region]>()
    let isUploading: Driver<Bool>
    let errorMessage = PublishSubject<String>()
    
    // MARK: Public
    weak var delegate: ListRegionsViewModelDelegate?
    
    // MARK: Private
    private let repository: CitiesRepositoryType
    private let errorFabric = ErrorMessageFabric()
    private let activityIndicator = ActivityIndicator()
    private let bag = DisposeBag()
    
    init(repository: CitiesRepositoryType) {
        self.repository = repository
        self.isUploading = activityIndicator.asDriver()
    }
    
    func uploadRegions() {
        repository.getAllRegionsAndCities()
            .trackActivity(activityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] regions in
                self?.regions.onNext(regions)
            },
            onError: { [weak self] error in
                self?.showErrorMessage(error)
            })
            .disposed(by: bag)
    }
    
    func didSelect(region: Region) {
        delegate?.userSelectRegion(with: region.cities)
    }
    
    internal func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
}
