//
//  ArticleRepositoryType.swift
//  TvoyaApteka
//
//  Created by BuidMac on 14.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

protocol ArticleRepositoryType {
    func getArticles(count: Int, offset: Int) -> Single<[Article]>
    func getArticle(id articleId: Int, in city: City) -> Single<Article>
}
