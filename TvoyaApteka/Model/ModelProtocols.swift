//
//  Protocols.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 21.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol RemoteImage {
    var images: [String] { get }
    func getMainImageUrl() -> URL?
}

extension RemoteImage {
    
    func getMainImageUrl() -> URL? {
        guard let urlName = images.first else { return nil }
        // Добавляем дробь, если ее нет
        return URL(string: urlName)
    }
    
}

extension UIImageView {
    
    func setAsyncImage(url: URL?, placeholder: UIImage? = UIImage(), completionHandler: ((UIImage?, NSError?) -> Void)? = nil) {
        if let url = url {
            self.kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: nil) { image, error, _, _ in
                completionHandler?(image, error)
            }
        }
    }
}
