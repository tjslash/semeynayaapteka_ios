//
//  Search.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 28.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SearchResults {
    
    let suggestions: String?
    let drugs: [Drug]
}

extension SearchResults: RemoteEntity {
    
    init?(json: JSON) {
        self.suggestions = json["suggest"].string
        self.drugs = json["drugs"].arrayValue.compactMap { Drug(json: $0) }
    }
}
