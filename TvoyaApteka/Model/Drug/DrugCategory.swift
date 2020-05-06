//
//  DrugCategory.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 15.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DrugCategory: RemoteEntity {
    
    let id: Int
    let title: String
    let parentId: Int?
    var subcategories: [DrugCategory] = []
    
    required init?(json: JSON) {
        guard
            let id = json["id"].int,
            let title = json["title"].string
            else { return nil }
        
        self.id = id
        self.title = title
        
        self.parentId = json["parent_id"].int
    }
    
}

extension DrugCategory {
    
    func getIcon() -> UIImage? {
        var iconName: String?
        switch id {
        case   4: iconName = "BAD" //бад
        case 103: iconName = "Soap" //гигиена и косметика
        case 105: iconName = "Balance" //диета спорт питание
        case 104: iconName = "Mother" //для мамы и малыша
        case   3: iconName = "Drugs" //лекарственные препараты
        case  10: iconName = "Plaster" //медицинские изделия
        case   7: iconName = "Thermometer" //медицинские приборы
        case 106: iconName = "Pack" //Прочие товары
        default: iconName = nil
        }
        return UIImage(named: iconName ?? "")
    }
    
}
