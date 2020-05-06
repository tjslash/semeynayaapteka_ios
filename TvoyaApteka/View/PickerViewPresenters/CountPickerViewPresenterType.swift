//
//  CountPickerViewPresenterType.swift
//  TvoyaApteka
//
//  Created by BuidMac on 07.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol CountPickerViewPresenterType {
    func showKeyboard(min minCount: Int, max maxCount: Int, doneHandler: ((_ selectCount: Int) -> Void)?)
}
