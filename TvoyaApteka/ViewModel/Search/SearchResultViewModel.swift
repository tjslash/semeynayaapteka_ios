//
//  SearchViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 02.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchResultViewModelDelegate: class {
    func didFoundResult(drugs: [Drug])
}

class SearchResultViewModel {
    
    // MARK: Input
    let searchBarText = Variable<String>("")
    let searchButtonDidTap = PublishSubject<Void>()
    
    // MARK: Output
    let searchResultIsEmpty = PublishSubject<Void>()
    let searchErrorMessage = PublishSubject<String>()
    let suggestions = PublishSubject<[String]>()
    let searchHistory = PublishSubject<[String]>()
    
    // MARK: Public
    weak var delegate: SearchResultViewModelDelegate?
    
    // MARK: Private
    private let drugRepository: DrugRepositoryType
    private let bag = DisposeBag()
    
    init(drugRepository: DrugRepositoryType) {
        self.drugRepository = drugRepository
        
        searchBarText
            .asDriver()
            .drive(onNext: { [unowned self] searchText in
                self.findSuggestions(by: searchText)
            })
            .disposed(by: bag)
        
        searchButtonDidTap
            .withLatestFrom(searchBarText.asDriver())
            .bind(onNext: { [unowned self] searchText in
                self.performSearch(text: searchText)
            })
            .disposed(by: bag)
    }
    
    func performSearch(text: String) {
        drugRepository.getSearchResults(query: text)
            .subscribe(onSuccess: { [unowned self] drugs in
                if drugs.isEmpty {
                    self.searchResultIsEmpty.onNext(())
                    return
                }

                self.delegate?.didFoundResult(drugs: drugs)
            })
            .disposed(by: bag)
    }
    
    private func findSuggestions(by text: String) {
        drugRepository.getSearchSuggestions(query: text)
            .subscribe(onSuccess: {  [unowned self] suggestions in
                if let suggestions = suggestions {
                    self.suggestions.onNext([suggestions])
                }
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: bag)
    }
    
}
