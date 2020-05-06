//
//  TagListView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 01.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import TagListView

extension TagListView {
    
    func deselectAll(except tagView: TagView) {
        tagView.isSelected = true
        
        for tag in self.tagViews where tag !== tagView {
            tag.isSelected = false
        }
    }
    
    func selectFirstTag(handler: (_ title: String) -> Void) {
        self.tagViews.first?.isSelected = true
        
        if let firstTag = self.tagViews.first {
            firstTag.isSelected = true
            handler(firstTag.titleLabel!.text!)
        }
    }
    
}
