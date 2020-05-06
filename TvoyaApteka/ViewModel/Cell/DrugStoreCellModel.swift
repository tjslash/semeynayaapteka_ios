//
//  DrugStoreCellModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

class DrugStoreCellModel {
    
    let drugStore: DrugStore
    let storeNameText: String
    let addressText: String
    let scheduleText: String
    let revisionText: String
    let revisionImageIsHidden: Bool
    
    init(drugStore: DrugStore) {
        self.drugStore = drugStore
        self.storeNameText = drugStore.title
        self.addressText = drugStore.address
        self.scheduleText = drugStore.getScheduleString()
        let revisionText = drugStore.getFreedayString()
        self.revisionText = revisionText ?? ""
        self.revisionImageIsHidden = (revisionText == nil) ? true : false
    }
    
}
