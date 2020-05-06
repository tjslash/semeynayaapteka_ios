//
//  ConfigurationListCitiesViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ConfigurationListCitiesViewModel: ListCitiesViewModelType {
    
    // MARK: Input
    var showWarningAlert: ((_ cancelHandler: @escaping () -> Void, _ doneHandler: @escaping () -> Void) -> Void)?
    
    // MARK: Output
    let cities: BehaviorSubject<[UserCity]>
    let isUploading: Driver<Bool>
    let errorMessage = PublishSubject<String>()
    
    // MARK: Public
    weak var delegate: ListCitiesViewModelDelegate?
    
    // MARK: Private
    private let activityIndicator = ActivityIndicator()
    private let bag = DisposeBag()
    
    init(cities: [UserCity]) {
        self.cities = BehaviorSubject<[UserCity]>(value: cities)
        self.isUploading = activityIndicator.asDriver()
    }
    
    func didSelect(city: UserCity) {
        delegate?.userSelect(city: city)
    }
    
}
