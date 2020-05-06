//
//  Reusable.swift
//  TvoyaApteka
//
//  Created by BuidMac on 03.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

protocol Reusable: class {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension Reusable {
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}

extension UITableViewCell: Reusable { }
extension UICollectionViewCell: Reusable { }
extension UITableViewHeaderFooterView: Reusable { }

// swiftlint:disable force_cast
extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as! T
    }
    
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionViewCell>(elementKind: String, indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
// swiftlint:enable force_cast
