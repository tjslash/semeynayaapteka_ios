//
//  UIPageControl.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 29/03/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

extension UIPageControl {
    
    var isLastPage: Bool {
        return self.currentPage == (self.numberOfPages - 1)
    }
    
}
