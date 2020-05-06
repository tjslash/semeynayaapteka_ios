//
//  DrugCategoriesService.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 02.04.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift

class DrugCategoriesAPI: DrugCategoriesAPIProtocol {
    
    private let adapter = NetworkAdapter<DrugCategoriesRequest>()
    
    func getAllCategoriesTree() -> Single<[DrugCategory]> {
        return adapter.send(request: .getAllCategories)
            .mapArray(to: DrugCategory.self, keyPath: "data")
            .map({ allCategoriesArray in
                // Создаем словарь с ключем по id категории
                var categoriesDictionary: [Int: DrugCategory] = [:]
                
                // заполняем этот словарь, тривиальным образом
                for category in allCategoriesArray {
                    categoriesDictionary[category.id] = category
                }
                
                // Заполняем в общем списке категорий обратные ссылки на детей
                for category in allCategoriesArray {
                    if let parentId = category.parentId {
                        guard let parentCategory = categoriesDictionary[parentId] else { continue }
                        parentCategory.subcategories.append(category)
                    }
                }
                
                // Список корневых категорий, у которых нет родителя
                let rootCategories = allCategoriesArray.filter { $0.parentId == nil }
                
                return rootCategories
            })
    }
    
}
