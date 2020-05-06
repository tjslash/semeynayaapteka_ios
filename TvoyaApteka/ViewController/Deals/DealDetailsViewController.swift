//
//  DealDetailsPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 13.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift

protocol DealDetailsViewControllerDelegate: BaseViewControllerDelegate {
    func authorizationRequired()
    func didSelected(drug: Drug)
}

class DealDetailsViewController: BaseViewController {
    
    private var promotionCellViewModel: DealCellModel?
    private var drugCellModels: [DrugCellModel] = []
    private let bag = DisposeBag()
    private let tableView = UITableView.tableView
    private let countPickerViewPresenter: UIView & CountPickerViewPresenterType = CountPickerViewPresenter()
    private let viewModel: DealDetailsViewModel
    
    public weak var delegate: DealDetailsViewControllerDelegate?
    
    init(viewModel: DealDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.taAlmostWhite
        setupLayout()
        addSearchBarButton()
        tableView.dataSource = self
        tableView.delegate = self
        binding()
        viewModel.uploadPromo()
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(countPickerViewPresenter)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    private func binding() {
        viewModel.isUploading
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.errorMessages
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.title
            .asDriver()
            .drive(self.rx.title)
            .disposed(by: bag)
        
        viewModel.cellModels
            .bind(onNext: { [unowned self] models in
                self.promotionCellViewModel = models.deal
                self.drugCellModels = models.drugs
                self.tableView.reloadData()
            })
            .disposed(by: bag)
        
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
    
}

// MARK: - UITableView
extension DealDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard promotionCellViewModel != nil else { return 0 }
        return 1 + (drugCellModels.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard promotionCellViewModel != nil else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as DealCell
            cell.viewModel = promotionCellViewModel
            cell.subtitleLabel.isHidden = true
            cell.descriptionLabel.isHidden = true
            return cell
        } else {
            let drugIndex = indexPath.row - 1
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as DrugCardTableViewCell
            cell.viewModel = drugCellModels[drugIndex]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard indexPath.row != 0 else { return }
        guard promotionCellViewModel != nil else { return }
        
        let drugIndex = indexPath.row - 1
        delegate?.didSelected(drug: drugCellModels[drugIndex].drug)
    }
    
}

// MARK: Static UITableView fabric
private extension UITableView {
    
    static var tableView: UITableView {
        let tableView = UITableView()
        tableView.register(DealCell.self, forCellReuseIdentifier: DealCell.identifier)
        tableView.register(DrugCardTableViewCell.self, forCellReuseIdentifier: DrugCardTableViewCell.identifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 165
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }
    
}
