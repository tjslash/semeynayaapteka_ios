//
//  AddressDropListView.swift
//  TvoyaAptekaInterface
//
//  Created by BuidMac on 11.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public class AddressDropListView: DropListView {
    
    // MARK: Public API
    public var didChangedAdress: ((Int) -> Void)?
    
    /// Current selected row
    public var selectedRow: Int? {
        didSet {
            guard let selectedRow = selectedRow, !dataSource.isEmpty, selectedRow >= 0, selectedRow < dataSource.keys.count else {
                selectedValue = nil
                return
            }
            let keys = dataSource.keys.map { $0 }
            selectedValue = dataSource[keys[selectedRow]]
            selectedId = keys[selectedRow]
        }
    }
    
    private(set) public var selectedId: Int?
    
    public func setSelectedId(id: Int) {
        let keys = dataSource.keys.map { $0 }
        for index in 0..<keys.count where keys[index] == id {
            selectedRow = index
        }
    }
    
    /// Get current selected value from custom array
    private(set) var selectedValue: NSAttributedString? {
        didSet {
            textField.attributedText = selectedValue
        }
    }
    
    /// Custom data in default UIPickerView
    public var dataSource: [Int: NSAttributedString] = [:] {
        didSet {
            textField.reloadInputViews()
            if !dataSource.isEmpty {
                selectedRow = 0
            }
            
            keys = dataSource.keys.map { $0 }
        }
    }
    
    // MARK: Private API
    private lazy var picker: UIPickerView = {
        let textPicker = TextPicker()
        textPicker.delegate = self
        textPicker.dataSource = self
        return textPicker
    }()
    
    private var tempSelectedRow: Int = 0
    private var keys: [Int] = []
    
    public init(data: [Int: NSAttributedString]) {
        super.init(frame: .zero)
        setupStyle()
        setupPickerView()
        dataSource = data
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupPickerView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        self.rightView = UIImageView(image: #imageLiteral(resourceName: "DownArrow"))
        self.rightView.tintColor = .taAlmostWhite
        self.rightView.backgroundColor = .taPrimary
        self.rightView.contentMode = .center
        self.textField.textColor = .taGray
        self.textField.tintColor = .clear
    }
    
    private func setupPickerView() {
        textField.inputView = picker
        textField.inputAccessoryView = getToolbar()
    }
    
    private func getToolbar() -> UIToolbar {
        let toolBar = DoneCancelToolbar()
        
        toolBar.doneAction = { [unowned self] in
            self.selectedRow = self.tempSelectedRow
            self.endEditing(true)
            
            if !self.dataSource.isEmpty {
                let keys = self.dataSource.keys.map { $0 }
                let selectedId = keys[self.tempSelectedRow]
                self.didChangedAdress?(selectedId)
            }
        }
        
        toolBar.cancelAction = { [unowned self] in
            self.endEditing(true)
            if let selectedRow = self.selectedRow {
                self.picker.selectRow(selectedRow, inComponent: 0, animated: false)
            }
        }
        
        return toolBar
    }
    
}

// MARK: UIPickerViewDataSource
extension AddressDropListView: UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.keys.count
    }

}

// MARK: UIPickerViewDelegate
extension AddressDropListView: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return dataSource[keys[row]]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tempSelectedRow = row
    }

}
