//
//  ArticleService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 04.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class ArticleAPI: ArticleAPIProtocol {
    
    private let adapter = NetworkAdapter<ArticleRequest>()
    
    func getArticlesList(from: Int, count: Int) -> Single<[Article]> {
        guard from >= 0, count >= 0 else { return Single.just([]) }
        return adapter.send(request: .articlesList(from: from, count: count))
            .mapArray(to: Article.self, keyPath: "data")
    }
    
    func getArticle(cityId: Int, articleId: Int) -> Single<Article> {
        return adapter.send(request: .article(inCity: cityId, id: articleId))
            .mapObject(to: Article.self, keyPath: "data")
    }
    
}
