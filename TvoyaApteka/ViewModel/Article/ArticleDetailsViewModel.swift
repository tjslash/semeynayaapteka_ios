//
//  NewsDetailsViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 02.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ArticleDetailsViewModel {
    
    // MARK: Input
    
    // MARK: Output
    let isUpoadData: Driver<Bool>
    let article = PublishSubject<Article>()
    let errorMessage = PublishSubject<String>()
    
    // MARK: Private
    private let repository: ArticleRepositoryType
    private let errorFabric = ErrorMessageFabric()
    private let activityIndicator = ActivityIndicator()
    private let articleId: Int
    private let userCity: City
    private let bag = DisposeBag()
    
    init(id articleId: Int, userCity: City, repository: ArticleRepositoryType) {
        self.articleId = articleId
        self.userCity = userCity
        self.repository = repository
        isUpoadData = activityIndicator.asDriver()
        uploadArticle()
    }
    
    private func uploadArticle() {
        repository.getArticle(id: articleId, in: userCity)
            .trackActivity(activityIndicator)
            .asSingle()
            .subscribe(onSuccess: { [weak self] article in
                self?.article.onNext(article)
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
