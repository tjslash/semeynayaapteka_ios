//
//  TextPicker.swift
//  TvoyaApteka
//
//  Created by BuidMac on 28.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class TextPicker: UIPickerView {
    
    var didSelected: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyStyle() {
        backgroundColor = .white
    }
    
}

class DoneCancelToolbar: UIToolbar {
    
    var doneAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPicker() {
        backgroundColor = UIColor.white
        barStyle = UIBarStyle.default
        isTranslucent = false
        
        let doneButton = getBarButton(.done, action: #selector(tapDoneButton(_:)))
        let cancelButton = getBarButton(.cancel, action: #selector(tapCancelButton(_:)))
        let spacer = getSpaser()
        items = [cancelButton, spacer, doneButton]
        sizeToFit()
    }
    
    private enum ButtonType {
        case done, cancel
        
        var text: String {
            switch self {
            case .cancel:
                return "Отмена"
            case .done:
                return "Готово"
            }
        }
    }
    
    private func getBarButton(_ type: ButtonType, action: Selector) -> UIBarButtonItem {
        let barButton = UIBarButtonItem(title: type.text,
                                         style: UIBarButtonItemStyle.done,
                                         target: self,
                                         action: action)
        barButton.tintColor = .taPrimary
        return barButton
    }
    
    private func getSpaser() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    // MARK: Actions
    @objc
    func tapDoneButton(_ sender: UIBarButtonItem) {
       doneAction?()
    }
    
    @objc
    func tapCancelButton(_ sender: UIBarButtonItem) {
        cancelAction?()
    }
    
}
