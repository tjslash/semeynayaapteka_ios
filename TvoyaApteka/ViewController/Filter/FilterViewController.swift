//
//  FilterPage.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 24/04/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

protocol FilterViewControllerDelegate: class {
    func applyDrugFilter(_ filter: DrugFilter)
}

class FilterViewController: BaseViewController {
    
    enum SortStrings: String {
        case upPrice = "По возрастанию цены"
        case downPrice = "По убыванию цены"
        case alphabetical = "В алфавитном порядке"
        
        static var allCases: [SortStrings] {
            return [.upPrice, .downPrice, .alphabetical]
        }
        
        static var allStrings: [String] {
            return allCases.compactMap { $0.rawValue }
        }
    }
    
    private let clearButton = UIButton.clearButton
    private let sortLabel = UILabel.sortLabel
    private let sortTextField = UIButton.sortTextField
    private let priceLabel = UILabel.priceLabel
    private let minPriceTextField = UITextField.minPriceTextField
    private let maxPriceTextField = UITextField.maxPriceTextField
    private let minusLabel = UILabel.minusLabel
    private let manufacturerImage = UIImageView.manufacturerImage
    private let manufacturerButton = UIButton.manufacturerButton
    
    private var selectedManufacturers = Set<Int>()
    private let drugRepository: DrugRepositoryType
    private let bag = DisposeBag()
    
    weak var delegate: FilterViewControllerDelegate?
    
    init(drugRepository: DrugRepositoryType) {
        self.drugRepository = drugRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Фильтр"
        view.backgroundColor = .taAlmostWhite
        setupSubviews()
        setupLayout()
        addApplyBarButton()
        addDoneToolBar(textField: minPriceTextField)
        addDoneToolBar(textField: maxPriceTextField)
        bindUI()
        sortTextField.addTarget(self, action: #selector(showSortItemsList), for: .touchUpInside)
        manufacturerButton.addTarget(self, action: #selector(showManufacturerPage), for: .touchUpInside)
    }

    private func addApplyBarButton() {
        let button = UIBarButtonItem(title: "Применить".uppercased(), style: .plain, target: self, action: #selector(applyFilter))
        button.tintColor = UIColor.taAlmostWhite.withAlphaComponent(0.8)
        addAsFirstItem(item: button)
    }
    
    func loadFilter() {
        selectSortItemHandler(item: SortStrings.upPrice.rawValue)
        let filter = drugRepository.getDrugFilter()
        setFilter(filter: filter)
    }
    
    @objc
    private func applyFilter() {
        let filter = createFilterFromPage()
        delegate?.applyDrugFilter(filter)
    }
    
    @objc
    private func showManufacturerPage() {
        let page = ManufacturerViewController(drugRepository: drugRepository, selected: selectedManufacturers)
        page.delegate = self
        navigationController?.pushViewController(page, animated: true)
    }
    
    private func bindUI() {
        clearButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.clearFiler()
                self?.applyFilter()
            }).disposed(by: bag)
    }
    
    private func clearFiler() {
        selectSortItemHandler(item: SortStrings.upPrice.rawValue)
        minPriceTextField.text = ""
        maxPriceTextField.text = ""
        selectedManufacturers = Set<Int>()
    }
    
    private func setupSubviews() {
        view.addSubview(clearButton)
        view.addSubview(sortLabel)
        view.addSubview(sortTextField)
        view.addSubview(priceLabel)
        view.addSubview(minPriceTextField)
        view.addSubview(minusLabel)
        view.addSubview(maxPriceTextField)
        view.addSubview(manufacturerButton)
        manufacturerButton.addSubview(manufacturerImage)
    }
    
    private func setupLayout() {
        clearButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(48)
        }
        
        sortLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(clearButton.snp.bottom).offset(32)
            make.width.equalTo(90)
        }
        
        sortTextField.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(24)
            make.centerY.equalTo(sortLabel)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(sortLabel.snp.bottom).offset(45)
            make.right.equalToSuperview().offset(-16)
        }
        
        minPriceTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
            make.right.equalTo(view.snp.centerX).offset(-16)
        }
        
        maxPriceTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.centerX).offset(16)
            make.top.equalTo(minPriceTextField)
            make.right.equalToSuperview().offset(-16)
        }
        
        minusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(minPriceTextField.snp.right)
            make.right.equalTo(maxPriceTextField.snp.left)
            make.top.height.equalTo(minPriceTextField)
        }
        
        manufacturerButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
            make.top.equalTo(minPriceTextField.snp.bottom).offset(40)
        }
        
        manufacturerImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
        }
    }
    
    func setFilter(filter: DrugFilter) {
        if let priceMin = filter.priceMin {
            minPriceTextField.text = String(priceMin)
        }
        if let priceMax = filter.priceMax {
            maxPriceTextField.text = String(priceMax)
        }
        
        _ = filter.manufacturers.compactMap { selectedManufacturers.insert($0) }
        
        guard let sort = filter.sort else { return }
        if sort == .price {
            guard let order = filter.order else { return }
            switch order {
            case .asc:
                selectSortItemHandler(item: SortStrings.upPrice.rawValue)
            case .desc:
                selectSortItemHandler(item: SortStrings.downPrice.rawValue)
            }
        }
        if sort == .title {
            selectSortItemHandler(item: SortStrings.alphabetical.rawValue)
        }
    }
    
    func createFilterFromPage() -> DrugFilter {
        var ret = DrugFilter()
        
        if let priceMin = Double(minPriceTextField.text ?? "") {
            ret.priceMin = priceMin
        }
        if let priceMax = Double(maxPriceTextField.text ?? "") {
            ret.priceMax = priceMax
        }
        if let text = sortTextField.titleLabel?.text {
            switch text {
            case SortStrings.upPrice.rawValue:
                ret.sort = .price
                ret.order = .asc
            case SortStrings.downPrice.rawValue:
                ret.sort = .price
                ret.order = .desc
            case SortStrings.alphabetical.rawValue:
                ret.sort = .title
            default: break
            }
        }
        ret.manufacturers = Array(selectedManufacturers)
        return ret
    }
    
    @objc
    private func showSortItemsList() {
        let alert = createSortItemsAlert(itemsTitle: SortStrings.allStrings, selectHandler: selectSortItemHandler)
        present(alert, animated: true, completion: nil)
    }
    
    private func createSortItemsAlert(itemsTitle: [String], selectHandler: ((String) -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for title in itemsTitle {
            let itemAction = UIAlertAction(title: title, style: .default) { _ in
                selectHandler?(title)
            }
            
            alertController.addAction(itemAction)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    private func selectSortItemHandler(item: String) {
        changeSortTitle(text: item)
    }
    
    private func changeSortTitle(text: String) {
        sortTextField.setTitle(text, for: .normal)
    }
    
}

// MARK: - ManufacturerPageDelegate
extension FilterViewController: ManufacturerViewControllerDelegate {
    
    func setManufacturersIds(ids: Set<Int>) {
        self.selectedManufacturers = ids
    }
    
}

// MARK: Static UIButton fabric
private extension UIButton {
    
    static var clearButton: UIButton {
        let button = ActionButton(title: "Очистить все фильтры".uppercased())
        return button
    }
    
    static var sortTextField: UIButton {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(#imageLiteral(resourceName: "DownArrowGray"), for: .normal)
        button.contentMode = .right
        button.imageView?.tintColor = UIColor.taGray
        button.setTitleColor(UIColor.taBlack, for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }
    
    static var manufacturerButton: UIButton {
        let btn = UIButton()
        btn.setTitle("Производитель", for: .normal)
        btn.setTitleColor(.taBlack, for: .normal)
        btn.setTitleColor(.taPrimary, for: .highlighted)
        btn.titleLabel?.font = UIFont.Title.h2
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return btn
    }
    
}

// MARK: Static UILabel fabric
private extension UILabel {
    
    static var sortLabel: UILabel {
        let label = UILabel()
        label.text = "Сортировка"
        label.font = UIFont.Title.h4
        label.textColor = .taGray
        return label
    }
    
    static var priceLabel: UILabel {
        let label = UILabel()
        label.text = "Цена, руб.:"
        label.font = UIFont.Title.h4
        label.textColor = .taGray
        return label
    }
    
    static var minusLabel: UILabel {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .center
        label.font = UIFont.Title.h4
        label.textColor = .taBlack
        return label
    }
    
}

// MARK: Static UITextField fabric
private extension UITextField {
    
    static var minPriceTextField: UITextField {
        let textField = FlatTextField()
        textField.keyboardType = .numberPad
        return textField
    }
    
    static var maxPriceTextField: UITextField {
        let textField = FlatTextField()
        textField.keyboardType = .numberPad
        return textField
    }
    
}

// MARK: Static UIImageView fabric
private extension UIImageView {
 
    static var manufacturerImage: UIImageView {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "RightArrow")
        imageView.contentMode = .center
        imageView.tintColor = UIColor.taPrimary
        return imageView
    }
    
}
