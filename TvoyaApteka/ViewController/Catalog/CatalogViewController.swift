//
//  CatalogPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 19.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import TagListView
import RxSwift
import RxCocoa

protocol CatalogViewControllerDelegate: BaseViewControllerDelegate {
    func selectCategory(_ category: DrugCategory)
    func didSelected(drug: Drug)
    func authorizationRequired()
}

class CatalogViewController: ScrollViewController {
    
    // MARK: View property
    private let catalogList = CatalogCategoryView(items: [])
    private let titleLabel = UILabel.titleLabel
    private let tagsView = TagListView.tagsView
    private let actualActivityIndicator = UIActivityIndicatorView.grayIndicator
    private var actualDrugsSlider = DrugSliderView.actualDrugsSlider
    private let saleActivityIndicator = UIActivityIndicatorView.grayIndicator
    private let hitDrugsSlider = DrugSliderView.hitDrugsSlider
    private let hitActivityIndicator = UIActivityIndicatorView.grayIndicator
    private let saleDrugsSlider = DrugSliderView.saleDrugsSlider
    
    // MARK: Public
    weak var delegate: CatalogViewControllerDelegate?
    
    // MARK: Private property
    private var categories: [DrugCategory] = [] {
        didSet {
            updateCatalogList()
        }
    }
    
    private var tags: [ActualCategory] = [] {
        didSet {
            initialActualDrugs()
        }
    }
    
    private var viewModel: CatalogViewModel
    private let bag = DisposeBag()
    private let countPickerViewPresenter: UIView & CountPickerViewPresenterType = CountPickerViewPresenter()
    
    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.setContentOffset(CGPoint.zero, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Каталог"
        view.backgroundColor = .taAlmostWhite
        addSearchBarButton()
        binding()
        viewModel.uploadData()
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        view.addSubview(countPickerViewPresenter)
        
        contentView.addSubview(catalogList)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tagsView)
        contentView.addSubview(actualActivityIndicator)
        contentView.addSubview(actualDrugsSlider)
        contentView.addSubview(hitDrugsSlider)
        contentView.addSubview(hitActivityIndicator)
        contentView.addSubview(saleActivityIndicator)
        contentView.addSubview(saleDrugsSlider)
        
        catalogList.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(catalogList.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        tagsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        actualDrugsSlider.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(tagsView.snp.bottom)
        }
        
        actualActivityIndicator.snp.makeConstraints { make in
            make.center.equalTo(actualDrugsSlider)
        }
        
        saleActivityIndicator.snp.makeConstraints { make in
            make.center.equalTo(hitDrugsSlider)
        }
        
        hitActivityIndicator.snp.makeConstraints { make in
            make.center.equalTo(saleDrugsSlider)
        }
        
        hitDrugsSlider.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(actualDrugsSlider.snp.bottom).offset(16)
        }
        
        saleDrugsSlider.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(hitDrugsSlider.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func binding() {
        bindingUpdateData()
        bindingErrorActions()
        bindingLoadingActions()
        bindingHandlers()
    }
    
    private func bindingUpdateData() {
        viewModel.listCategories
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] categories in
                self.categories = categories
            })
            .disposed(by: bag)
        
        viewModel.hitCellModels
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] cellModels in
                self.showSlider(self.hitDrugsSlider, cellModels: cellModels)
            })
            .disposed(by: bag)
        
        viewModel.saleCellModels
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] cellModels in
                self.showSlider(self.saleDrugsSlider, cellModels: cellModels)
            })
            .disposed(by: bag)
        
        viewModel.listTitleActual
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] tags in
                self.tags = tags
            })
            .disposed(by: bag)
        
        viewModel.actualCellModels
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] cellModels in
                self.showSlider(self.actualDrugsSlider, cellModels: cellModels)
            })
            .disposed(by: bag)
    }
    
    private func bindingErrorActions() {
        viewModel.showNotConnectionView
            .bind(to: self.rx.showNotConnection)
            .disposed(by: bag)
        
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
    }
    
    private func bindingLoadingActions() {
        viewModel.isLoading
            .asDriver()
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.hitIsLoading
            .asDriver()
            .drive(onNext: { [unowned self] isLoading in
                self.animateSlider(self.hitDrugsSlider, indicator: self.hitActivityIndicator, animate: isLoading)
            })
            .disposed(by: bag)
        
        viewModel.saleIsLoading
            .asDriver()
            .drive(onNext: { [unowned self] isLoading in
                self.animateSlider(self.saleDrugsSlider, indicator: self.saleActivityIndicator, animate: isLoading)
            })
            .disposed(by: bag)
        
        viewModel.actualIsLoading
            .asDriver()
            .drive(onNext: { [unowned self] isLoading in
                self.animateSlider(self.actualDrugsSlider, indicator: self.actualActivityIndicator, animate: isLoading)
            })
            .disposed(by: bag)
    }
    
    private func bindingHandlers() {
        viewModel.showRecipeAlert = { [unowned self] doneHandler in
            self.showPrescriptionDrugAlert(completion: doneHandler)
        }
        
        viewModel.showCount = { [unowned self] min, max, successHandler in
            self.countPickerViewPresenter.showKeyboard(min: min, max: max, doneHandler: successHandler)
        }
        
        viewModel.notAuthorization = { [unowned self] in
            self.delegate?.authorizationRequired()
        }
    }
    
    private func updateCatalogList() {
        catalogList.categoryItems = categories.map { CategoryItem(image: $0.getIcon() ?? UIImage(), title: $0.title) }
        setupActionWhenCatalogItemDidSelect()
    }
    
    private func initialActualDrugs() {
        updateTagView(tags: tags)
        
        tagsView.selectFirstTag { [unowned self] tagTitle in
            self.uploadActual(by: tagTitle)
        }
    }
    
}

extension CatalogViewController {
    
    private func showSlider(_ slider: DrugSliderView, cellModels: [DrugCellModel]) {
        slider.countCells = cellModels.count
        
        slider.configureCellForRow = { cell, indexPath in
            cell.viewModel = cellModels[indexPath.row]
            return cell
        }
        
        slider.didSelect = { [weak self] indexPath in
            self?.delegate?.didSelected(drug: cellModels[indexPath.row].drug)
        }
        
        slider.reload()
    }
    
    private func animateSlider(_ slider: DrugSliderView, indicator activityIndicator: UIActivityIndicatorView, animate: Bool) {
        animate ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        slider.contentIsHidden = animate
    }
    
    private func setupActionWhenCatalogItemDidSelect() {
        catalogList.didSelectItem = { [unowned self] row in
            guard self.categories.indices.contains(row) else { return }
            self.delegate?.selectCategory(self.categories[row])
        }
    }
    
    private func updateTagView(tags: [ActualCategory]) {
        tagsView.removeAllTags()
        
        for title in tags.map({ $0.title }) {
            let tag = tagsView.addTag(title)
            
            tag.onTap = { [unowned self] tagView in
                self.tagsView.deselectAll(except: tagView)
                self.uploadActual(by: title)
            }
        }
    }
    
    private func uploadActual(by title: String) {
        if let tagId = findIdInTags(title: title) {
            viewModel.uploadActualDrugs(by: tagId)
        } else {
            print("Title: \(title) is not found")
        }
    }
    
    private func findIdInTags(title: String) -> Int? {
        for tag in tags where tag.title == title {
            return tag.id
        }
        return nil
    }
    
}

// MARK: - Static Label fabric
private extension UILabel {
    
    static var titleLabel: UILabel {
        let label = UILabel()
        label.text = "Актуальное".uppercased()
        label.font = UIFont.Title.h2Bold
        label.textColor = .taPrimary
        return label
    }
    
}

// MARK: - Static TagListView fabric
private extension TagListView {
    
    static var tagsView: TagListView {
        let tagListView = TagListView()
        tagListView.textFont = UIFont.Title.h3
        tagListView.tagBackgroundColor = .taAlmostWhite
        tagListView.borderWidth = 1
        tagListView.textColor = .taGray
        tagListView.borderColor = .taGray
        tagListView.selectedTextColor = .taPrimary
        tagListView.selectedBorderColor = .taPrimary
        tagListView.marginX = 10
        tagListView.marginY = 10
        tagListView.paddingX = 16
        tagListView.paddingY = 5
        tagListView.cornerRadius = 14
        return tagListView
    }
    
}

// MARK: - Static UIActivityIndicatorView fabric
private extension UIActivityIndicatorView {
    
    static var grayIndicator: UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.startAnimating()
        return indicator
    }
    
}

// MARK: - Static DrugSliderView fabric
private extension DrugSliderView {
    
    static var actualDrugsSlider: DrugSliderView {
        let slider = DrugSliderView(title: "")
        return slider
    }
    
    static var hitDrugsSlider: DrugSliderView {
        let slider = DrugSliderView(title: "Хиты продаж".uppercased())
        slider.tintColor = .taRed
        let emptyLabel = UILabel(text: "Список пуст")
        emptyLabel.font = UIFont.Title.h4
        emptyLabel.textAlignment = .center
        slider.emptyView = emptyLabel
        return slider
    }
    
    static var saleDrugsSlider: DrugSliderView {
        let slider = DrugSliderView(title: "Товары по акциям".uppercased())
        let emptyLabel = UILabel(text: "Список пуст")
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont.Title.h4
        slider.emptyView = emptyLabel
        slider.tintColor = .taOrange
        return slider
    }
    
}
