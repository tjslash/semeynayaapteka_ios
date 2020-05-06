//
//  Initializable.swift
//  TvoyaApteka
//
//  Created by BuidMac on 03.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

protocol Initializable {
    static func initalize() -> Self?
}

extension UIViewController: Initializable {
    static func initalize() -> Self? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        return storyboard.getInitialVC(type: self)
    }
}

extension UIView: Initializable {
    static func initalize() -> Self? {
        func instanceFromNib<T: UIView>() -> T? {
            return UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as? T
        }
        
        return instanceFromNib()
    }
}

extension UIStoryboard {
    func getInitialVC<T: UIViewController>(type: T.Type) -> T? {
        return instantiateInitialViewController() as? T
    }
}
