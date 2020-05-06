//
//  CountPickerViewPresenter.swift
//  TvoyaApteka
//
//  Created by BuidMac on 07.06.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

class CountPickerViewPresenter: UITextField, CountPickerViewPresenterType {
    
    /// Show count picker and to return count that selected user or not to call doneHandler if user selected cancel
    ///
    /// - Parameters:
    ///   - minCount: min count item, by default is 1
    ///   - maxCount: max count item, by default is 100
    ///   - doneHandler: call if user to selected any count
    public func showKeyboard(min minCount: Int = 1, max maxCount: Int = 100, doneHandler: ((_ selectCount: Int) -> Void)?) {
        updateDataSource(min: minCount, max: maxCount)
        selectedRow = 0
        tempSelectedRow = 0
        countPicker.selectRow(selectedRow, inComponent: 0, animated: false)
        self.becomeFirstResponder()
        doneAction = doneHandler
    }
    
    private var countSource: [Int] = []
    
    private lazy var countPicker: UIPickerView = {
        let countPicker = UIPickerView()
        countPicker.delegate = self
        countPicker.dataSource = self
        countPicker.backgroundColor = .white
        return countPicker
    }()
    
    init() {
        super.init(frame: .zero)
        self.inputView = countPicker
        self.inputAccessoryView = createToolbar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createToolbar() -> UIToolbar {
        let cancelButton = UIBarButtonItem(title: "Отмена",
                                           style: UIBarButtonItemStyle.done,
                                           target: self,
                                           action: #selector(tapCancelButton))
        
        let doneButton = UIBarButtonItem(title: "Готово",
                                         style: UIBarButtonItemStyle.done,
                                         target: self,
                                         action: #selector(tapDoneButton))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                     target: nil,
                                     action: nil)
        
        cancelButton.tintColor = .taPrimary
        doneButton.tintColor = .taPrimary
        
        let amountToolbar = UIToolbar(frame: CGRect.zero)
        amountToolbar.backgroundColor = UIColor.white
        amountToolbar.barStyle = UIBarStyle.default
        amountToolbar.isTranslucent = false
        amountToolbar.items = [cancelButton, spacer, doneButton]
        amountToolbar.sizeToFit()
        return amountToolbar
    }
    
    private var selectedRow: Int = 0
    private var tempSelectedRow: Int = 0
    private var doneAction: ((Int) -> Void)?
    
    // MARK: PickerView
    private func updateDataSource(min: Int, max: Int) {
        countSource.removeAll()
        
        for index in min...max {
            countSource.append(index)
        }
    }
    
    @objc
    private func tapDoneButton() {
        self.endEditing(true)
        let count = countSource[tempSelectedRow]
        doneAction?(count)
    }
    
    @objc
    private func tapCancelButton() {
        self.endEditing(true)
    }
    
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension CountPickerViewPresenter: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countSource.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(countSource[row])
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tempSelectedRow = row
    }
    
}
