//
//  DrugCardPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

protocol DrugDetailsViewControllerDelegate: class {
    func authorizationRequired()
    func didSelectedFullDescription(html: String)
    func didSelected(drug: Drug)
}

class DrugDetailsViewController: ScrollViewController {
    
    weak var delegate: DrugDetailsViewControllerDelegate?
    
    let drugDescription = DrugDescriptionView()
    let fullDescriptionView: UIView = FullDrugDescriptionView(text: "Подробное описание товара".uppercased(), image: #imageLiteral(resourceName: "RightArrow"))
    let analogDrugs = DrugSliderView(title: "Аналоги".uppercased())
    let oftenTakeDrugs = DrugSliderView(title: "С этим товаром часто берут".uppercased())
    let countPickerViewPresenter: UIView & CountPickerViewPresenterType = CountPickerViewPresenter()
    
    var isEnabled: Bool = true {
        didSet {
            self.drugDescription.buyView.buyButton.isEnabled = isEnabled
            self.drugDescription.buyView.addButton.isEnabled = isEnabled
            self.drugDescription.buyView.deleteButton.isEnabled = isEnabled
            self.drugDescription.storeTextField.textField.isEnabled = isEnabled
            self.drugDescription.storeTextField.rightView.isHidden = !isEnabled
        }
    }
    
    private let viewModel: DrugDetailsViewModel
    private let bag = DisposeBag()

    init(viewModel: DrugDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        setupLayout()
        binding()
        viewModel.uploadPageData()
    }
    
    override public func setupLayout() {
        super.setupLayout()
        
        let slidersStackView = UIStackView(arrangedSubviews: [analogDrugs, oftenTakeDrugs])
        slidersStackView.spacing = 16
        slidersStackView.axis = .vertical
        
        contentView.addSubview(drugDescription)
        contentView.addSubview(fullDescriptionView)
        contentView.addSubview(slidersStackView)
        contentView.addSubview(countPickerViewPresenter)
        
        drugDescription.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        fullDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(drugDescription.snp.bottom).offset(20)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        
        slidersStackView.snp.makeConstraints { make in
            make.top.equalTo(fullDescriptionView.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func binding() {
        inputBinding()
        outputBinding()
    }
    
    private func inputBinding() {
        drugDescription.favoriteButton.rx.tap
            .bind(to: viewModel.favoriteBottonDidTap)
            .disposed(by: bag)
        
        fullDescriptionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fullDescriptionViewDidTap)))
        
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
    
    private func outputBinding() {
        viewModel.showDescription
            .bind(onNext: { [unowned self] html in
                self.delegate?.didSelectedFullDescription(html: html)
            })
            .disposed(by: bag)
        
        viewModel.showEmptyAlert
            .bind(onNext: { [unowned self] in
                self.showEmptyDescriptionAlert()
            })
            .disposed(by: bag)
        
        viewModel.favoriteBottonIsEnable
            .drive(drugDescription.favoriteButton.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel.favoriteBottonIsSelected
            .asDriver(onErrorJustReturn: false)
            .drive(drugDescription.favoriteButton.rx.isSelected)
            .disposed(by: bag)
        
        viewModel.isUploading
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.cellModels
            .bind(onNext: { [unowned self] models in
                self.binding(models.page)
                self.showSlider(self.analogDrugs, cellModels: models.analogs)
                self.showSlider(self.oftenTakeDrugs, cellModels: models.oftenTake)
            })
            .disposed(by: bag)
    }
    
    @objc
    private func fullDescriptionViewDidTap() {
        viewModel.fullDescriptionViewDidTap.onNext(())
    }
    
    private func showEmptyDescriptionAlert() {
        let alert = UIAlertController(title: nil, message: "Подробное описание не найдено", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func binding(_ viewModel: DrugCellModel) {
        title = viewModel.titleText
        drugDescription.titleLabel.text = viewModel.titleText
        drugDescription.manufacturerLabel.text = viewModel.manufacturerText
        drugDescription.drugImageView.image = #imageLiteral(resourceName: "NoPhoto")
        drugDescription.drugImageView.setAsyncImage(url: viewModel.drugImageUrl)
        drugDescription.recipeStatus = viewModel.recipeStatus
        drugDescription.price.currentCost = viewModel.currentCostText
        drugDescription.price.oldCost = viewModel.oldCostText
        drugDescription.price.discount = viewModel.discountText

        viewModel.secondaryText
            .bind(to: drugDescription.countlabel.rx.text)
            .disposed(by: bag)
        
        viewModel.viewIsEnable
            .bind(onNext: { [unowned self] isEnabled in
                self.isEnabled = isEnabled
            })
            .disposed(by: bag)
        
        viewModel.allDrugStores
            .bind(onNext: { [unowned self] addresses in
                self.drugDescription.storeTextField.dataSource = addresses
            })
            .disposed(by: bag)

        viewModel.currentDrugStoreId
            .bind(onNext: { [unowned self] id in
                self.drugDescription.storeTextField.setSelectedId(id: id)
            })
            .disposed(by: bag)

        viewModel.purchaseStatus
            .bind(onNext: { [unowned self] status in
                self.drugDescription.buyView.status = status
            })
            .disposed(by: bag)

        (drugDescription.buyView.buyButton as UIButton).rx.tap
            .bind(onNext: {
                viewModel.buyDrug()
            })
            .disposed(by: bag)

        (drugDescription.buyView.addButton as UIButton).rx.tap
            .bind(onNext: {
                viewModel.changeCountDrug()
            })
            .disposed(by: bag)

        (drugDescription.buyView.deleteButton as UIButton).rx.tap
            .bind(onNext: {
                viewModel.deleteDrug()
            })
            .disposed(by: bag)

        drugDescription.storeTextField.didChangedAdress = { id in
            viewModel.changeDrugStore(id: id)
        }

        viewModel.isBuyAnimation
            .bind(onNext: { [unowned self] isAnimate in
                self.animatedButton(self.drugDescription.buyView.buyButton, isAnimate: isAnimate)
            })
            .disposed(by: bag)

        viewModel.isAddAnimation
            .bind(onNext: { [unowned self] isAnimate in
                self.animatedButton(self.drugDescription.buyView.addButton, isAnimate: isAnimate)
            })
            .disposed(by: bag)

        viewModel.isDeleteAnimation
            .bind(onNext: { [unowned self] isAnimate in
                self.animatedButton(self.drugDescription.buyView.deleteButton, isAnimate: isAnimate)
            })
            .disposed(by: bag)
    }

    private func animatedButton(_ button: BuyActionItem, isAnimate: Bool) {
        isAnimate ? button.startWaiting() : button.stopWaiting()
        view.isUserInteractionEnabled = !isAnimate
    }
    
    deinit {
        print("Deinit \(self)")
    }
}

// MARK: setDrug
extension DrugDetailsViewController {
    
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
        slider.contentIsHidden = false
        slider.isHidden = cellModels.isEmpty
    }
    
}

//// MARK: - DrugCellModelDelegate
//extension DrugDetailsViewController: DrugCellModelDelegate {
//
//    func showError(error: Error) {
//        handleError(error)
//    }
//
//    func showAuthorizationAlert() {
//        delegate?.authorizationRequired()
//    }
//
//    func showRecipeAlert(successHandler: @escaping () -> Void) {
//        showPrescriptionDrugAlert(completion: successHandler)
//    }
//
//    func showCount(min: Int, max: Int, successHandler: @escaping (Int) -> Void) {
//        countPickerViewPresenter.showKeyboard(min: min, max: max, doneHandler: successHandler)
//    }
//
//}

// MARK: - FullDrugDescriptionView
private class FullDrugDescriptionView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.taLightGray
        label.font = UIFont.Title.h4
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.taPrimary
        return imageView
    }()
    
    private let topLine = UIView()
    private let bottomLine = UIView()
    
    init(text: String, image: UIImage) {
        super.init(frame: .zero)
        setupLayout()
        self.titleLabel.text = text
        self.iconView.image = image
        self.topLine.backgroundColor = UIColor.taLightGray
        self.bottomLine.backgroundColor = UIColor.taLightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(topLine)
        addSubview(titleLabel)
        addSubview(iconView)
        addSubview(bottomLine)
        
        topLine.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(iconView.snp.left).offset(10)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.bottom.right.left.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
