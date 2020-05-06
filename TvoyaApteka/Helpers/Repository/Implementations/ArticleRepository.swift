//
//  ArticleRepository.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class ArticleRepository: ArticleRepositoryType {
    
    func getArticles(count: Int, offset: Int) -> Single<[Article]> {
        return ServerAPI.article.getArticlesList(from: offset, count: count)
    }
    
    func getArticle(id articleId: Int, in city: City) -> Single<Article> {
        return ServerAPI.article.getArticle(cityId: city.id, articleId: articleId)
    }
    
}
