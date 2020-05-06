//
//  Constants.swift
//  TvoyaApteka
//
//  Created by BuidMac on 10.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

struct Const {
    
    static let drugCellHeight: CGFloat = 205
    static let tableViewRowHeight: CGFloat = 64
    static let disableSendingConfirmationSMS: TimeInterval = 300.0
    static let mapKey = "d2411cce-9abb-4239-9ec4-7cf8f03f8c81"
    static let localFavoriteStorageKey: String = "favoriteLocalStorageKey"
    
    struct Url {
        static let server = URL(string: "https://semeynayaapteka.ru")!
        static let bonusProgramm = URL(string: "https://www.tvoyaapteka.ru/news/bonusnaya-programma/")!
        static let support = URL(string: "tel://88002012010")!
    }
    
    struct DateFormat {
        static let bonusCard: String = "dd.MM.yyyy"
        static let bonusHistoryHeader: String = "dd MMMM, EEEE"
    }
    
    struct ValidationRules {
        static let passwordLength: Int = 6
        static let emailFormat: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    struct Mask {
        static let bonusCard = "# ###### ######"
        static let phone = "# (###) ###-##-##"
    }
    
}
