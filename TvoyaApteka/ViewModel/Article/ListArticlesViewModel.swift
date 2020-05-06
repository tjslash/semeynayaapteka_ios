//
//  ListNewsViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 02.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ListArticlesViewModel {
    
    // MARK: Input
    
    // MARK: Output
    let articles = Variable<[Article]>([])
    let isUploadData: Driver<Bool>
    let isLoadingMore: Driver<Bool>
    let isRefreshing: Driver<Bool>
    let errorMessage = PublishSubject<String>()
    
    // MARK: Private
    private let errorFabric = ErrorMessageFabric()
    private let repository: ArticleRepositoryType
    private let loadingMoreActivityIndicator = ActivityIndicator()
    private let uploadingActivityIndicator = ActivityIndicator()
    private let refreshingActivityIndicator = ActivityIndicator()
    private var loadMoreStatus = false
    private var atListEnd = false
    private let bag = DisposeBag()
    
    init(repository: ArticleRepositoryType) {
        self.repository = repository
        isUploadData = uploadingActivityIndicator.asDriver()
        isLoadingMore = loadingMoreActivityIndicator.asDriver()
        isRefreshing = refreshingActivityIndicator.asDriver()
    }
    
    func loadMore() {
        if loadMoreStatus == false && atListEnd == false {
            self.loadMoreStatus = true
            
            repository.getArticles(count: 8, offset: articles.value.count)
                .trackActivity(loadingMoreActivityIndicator)
                .asSingle()
                .subscribe(onSuccess: { [weak self] newArticles in
                    if newArticles.count == 0 {
                        self?.atListEnd = true
                        self?.loadMoreStatus = false
                    }
                    self?.articles.value.append(contentsOf: newArticles)
                    }, onError: { [weak self] error in
                        self?.loadMoreStatus = false
                        self?.showErrorMessage(error)
                })
                .disposed(by: bag)
        }
    }
    
    func uploadArticles() {
        repository.getArticles(count: 8, offset: 0)
            .trackActivity(uploadingActivityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] newArticles in
                if newArticles.count == 0 {
                    self?.atListEnd = true
                }
                
                self?.articles.value = newArticles
                }, onError: { [weak self] error in
                    self?.showErrorMessage(error)
            }).disposed(by: bag)
    }
    
    func refreshArticles() {
        repository.getArticles(count: 8, offset: 0)
            .trackActivity(refreshingActivityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] newArticles in
                if newArticles.count == 0 {
                    self?.atListEnd = true
                }
                
                self?.articles.value = newArticles
                }, onError: { [weak self] error in
                    self?.showErrorMessage(error)
            }).disposed(by: bag)
    }

    private func showErrorMessage(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
}
