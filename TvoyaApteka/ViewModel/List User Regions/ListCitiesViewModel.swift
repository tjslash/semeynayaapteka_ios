//
//  ListCitiesViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 03.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ListCitiesViewModelDelegate: class {
    func userSelect(city: City?)
}

class ListCitiesViewModel: ListCitiesViewModelType {
    
    // MARK: Input
    var showWarningAlert: ((_ cancelHandler: @escaping () -> Void, _ doneHandler: @escaping () -> Void) -> Void)?
    
    // MARK: Output
    let cities: BehaviorSubject<[City]>
    let isUploading: Driver<Bool>
    let errorMessage = PublishSubject<String>()
    
    // MARK: Public
    weak var delegate: ListCitiesViewModelDelegate?
    
    // MARK: Private
    private var selectedCity: City!
    private let cartManager: CartManagerType
    private let errorFabric = ErrorMessageFabric()
    private let appConfiguration = AppConfiguration.shared
    private let activityIndicator = ActivityIndicator()
    private let bag = DisposeBag()
    
    init(cities: [City], cartManager: CartManagerType) {
        self.cartManager = cartManager
        self.cities = BehaviorSubject<[City]>(value: cities)
        
        self.isUploading = activityIndicator.asDriver()
    }

    func didSelect(city: City) {
        self.selectedCity = city
        
        if isUserCity(city) {
            cancelSelectCity()
            return
        }
        
        if isCartNotEmpty {
            showWarningAlert?(cancelSelectCity, clearCartAndChangeCity)
            return
        }
        
        changeCity()
    }
    
    private func isUserCity(_ city: City) -> Bool {
        return appConfiguration.currentCity?.id == city.id
    }
    
    private var isCartNotEmpty: Bool {
        return cartManager.cart.value.isEmpty == false
    }
    
    private func clearCartAndChangeCity() {
        clearCart { [weak self] in
            self?.changeCity()
        }
    }
    
    private func cancelSelectCity() {
        self.delegate?.userSelect(city: nil)
    }
    
    private func changeCity() {
        delegate?.userSelect(city: selectedCity)
    }
    
    private func clearCart(successHandler: @escaping () -> Void) {
        cartManager.cancelOrder()
            .trackActivity(activityIndicator)
            .asCompletable()
            .subscribe(onCompleted: {
                successHandler()
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
