//
//  UIViewController+ChildVC.swift
//  TvoyaApteka
//
//  Created by BuidMac on 18.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

extension UIViewController {
  
  /// Add child view controller
  ///
  /// - Parameter child: view controller when will add
  func add(_ child: UIViewController) {
    addChildViewController(child)
    view.addSubview(child.view)
    
    child.view.snp.makeConstraints { make in
        make.top.equalTo(topLayoutGuide.snp.bottom)
        make.left.right.equalToSuperview()
        make.bottom.equalTo(bottomLayoutGuide.snp.top)
    }
    
    child.didMove(toParentViewController: self)
  }
  
  /// Remove self from parrent
  func remove() {
    guard parent != nil else {
      return
    }
    
    willMove(toParentViewController: nil)
    removeFromParentViewController()
    view.removeFromSuperview()
  }
  
}
