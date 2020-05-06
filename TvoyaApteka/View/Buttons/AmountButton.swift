//
//  AmountButton.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 10/04/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class AmountButton: RoundButton {
    
    // MARK: Properties
    private var selectedAmount: Int! = 1 {
        didSet {
            updateButtonTitle()
        }
    }
    private var dataArray: [Int] = []
    private var maxAmount: Int!
    private let amountPicker = UIPickerView()
    private var customInputView: UIView?
    override public var inputView: UIView? {
        get {
            return customInputView
        }
        set (newValue) {
            customInputView = newValue
        }
    }
    private var customInputAccessoryView: UIView?
    override public var inputAccessoryView: UIView? {
        get {
            return customInputAccessoryView
        }
        set (newValue) {
            customInputAccessoryView = newValue
        }
    }
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: Public methods
    public func getSelectedAmount() -> Int {
        return selectedAmount
    }
    
    // MARK: Private methods
    private func updateSelectedRow() {
        amountPicker.selectRow(selectedAmount-1, inComponent: 0, animated: false)
    }
    
    private func updateButtonTitle() {
        self.setTitle(String(selectedAmount), for: .normal)
    }
    
    private func setupButtonStyle() {
        self.layer.borderColor = UIColor.taGray.cgColor
        self.layer.borderWidth = 1
        self.setTitleColor(.taGray, for: .normal)
    }
    
    private func setupPickerView() {
        amountPicker.delegate = self
        amountPicker.backgroundColor = .white
        let amountToolbar = UIToolbar(frame: CGRect.zero)
        amountToolbar.backgroundColor = UIColor.white
        amountToolbar.barStyle = UIBarStyle.default
        amountToolbar.isTranslucent = false
        let doneButton = UIBarButtonItem(title: "Готово",
                                         style: UIBarButtonItemStyle.done,
                                         target: self,
                                         action: #selector(AmountButton.tapDoneButton(_:)))
        doneButton.tintColor = .taPrimary
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                     target: nil,
                                     action: nil)
        amountToolbar.items = [spacer, doneButton]
        amountToolbar.sizeToFit()
        self.inputView = amountPicker
        self.inputAccessoryView = amountToolbar
    }
    
    private func generateArray() {
        dataArray.removeAll()
        for index in 1...maxAmount {
            dataArray.append(index)
        }
    }
    
    // MARK: Initialization
    convenience init(selectedAmount: Int, maxAmount: Int) {
        self.init(maxAmount: maxAmount)
        self.selectedAmount = selectedAmount
        updateButtonTitle()
    }
    
    convenience init(maxAmount: Int) {
        self.init(frame: CGRect.zero)
        self.maxAmount = maxAmount
        generateArray()
        setupButtonStyle()
        setupPickerView()
        updateButtonTitle()
        self.addTarget(self, action: #selector(AmountButton.tapAmountButton(_:)), for: .touchDown)
    }
    
    // MARK: Actions
    @IBAction func tapAmountButton(_ sender: UIButton) {
        self.becomeFirstResponder()
        updateSelectedRow()
    }
    
    @IBAction func tapDoneButton(_ sender: UIBarButtonItem) {
        self.resignFirstResponder()
    }
    
}

// MARK: UIPickerViewDataSource
extension AmountButton: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.maxAmount
    }
}

// MARK: UIPickerViewDelegate
extension AmountButton: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(dataArray[row])
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedAmount = dataArray[row]
    }
}
