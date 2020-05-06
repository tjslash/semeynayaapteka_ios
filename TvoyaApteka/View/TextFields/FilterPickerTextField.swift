//
//  FilterPickerTextField.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 24/04/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class FilterPickerTextField: UITextField {
    
    private let arrowImageView = UIImageView()
    private let filterPicker = UIPickerView()
    private var dataArray: [String] = []
    private var selectedValue: String? {
        didSet {
            updateText()
        }
    }
    
    // MARK: Public methods
    public func getSelectedValue() -> String? {
        return selectedValue
    }
    
    public func setDataArray(dataArray: [String]) {
        self.dataArray.removeAll()
        self.dataArray = dataArray
    }
    
    // MARK: Private methods
    private func updateText() {
        self.text = selectedValue
    }
    
    private func setupTextField() {
        arrowImageView.contentMode = .center
        arrowImageView.image = #imageLiteral(resourceName: "DownArrowGray")
        arrowImageView.tintColor = UIColor.taGray
        self.clipsToBounds = true
        
        self.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(25)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupPickerView() {
        filterPicker.delegate = self
        filterPicker.dataSource = self
        filterPicker.backgroundColor = .white
        
        let doneButton = UIBarButtonItem(title: "Готово",
                                         style: UIBarButtonItemStyle.done,
                                         target: self,
                                         action: #selector(tapDoneButton(_:)))
        doneButton.tintColor = .taPrimary
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                     target: nil,
                                     action: nil)
        
        let addressToolbar = UIToolbar(frame: CGRect.zero)
        addressToolbar.backgroundColor = UIColor.white
        addressToolbar.barStyle = UIBarStyle.default
        addressToolbar.isTranslucent = false
        addressToolbar.items = [spacer, doneButton]
        addressToolbar.sizeToFit()
        
        inputView = filterPicker
        inputAccessoryView = addressToolbar
    }
    
    // MARK: Initialization
    convenience public init(data: [String]) {
        self.init(frame: CGRect.zero)
        self.dataArray = data
        setupTextField()
        setupPickerView()
        filterPicker.selectRow(0, inComponent: 0, animated: false)
        selectedValue = dataArray[0]
        updateText()
    }
    
    @objc
    private func tapDoneButton(_ sender: UIBarButtonItem) {
        endEditing(true)
    }
    
}

// MARK: UIPickerViewDataSource
extension FilterPickerTextField: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
}

// MARK: UIPickerViewDelegate
extension FilterPickerTextField: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(dataArray[row])
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = dataArray[row]
    }
}
