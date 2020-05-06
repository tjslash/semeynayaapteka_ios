//
//  DrugCellModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 27.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

protocol DrugCellModelDelegate: class {
    func showAuthorizationAlert()
    func showRecipeAlert(successHandler: @escaping () -> Void)
    func showCount(min: Int, max: Int, successHandler: @escaping (Int) -> Void)
    func showError(error: Error)
}

class DrugCellModel {
    
    // MARK: Output
    let titleText: String
    let manufacturerText: String
    let drugImageUrl: URL?
    let recipeStatus: RecipeStatus
    let currentCostText: String
    private(set) var oldCostText: String?
    private(set) var discountText: String?
    
    let secondaryText = BehaviorSubject<String>(value: "В наличии")
    var allDrugStores = BehaviorSubject<[Int: NSAttributedString]>(value: [:])
    var currentDrugStoreId = BehaviorSubject<Int>(value: 0)
    let viewIsEnable = BehaviorSubject<Bool>(value: true)
    let purchaseStatus = BehaviorSubject<PurchaseStatus>(value: .notBought)
    let isBuyAnimation = BehaviorSubject<Bool>(value: false)
    let isAddAnimation = BehaviorSubject<Bool>(value: false)
    let isDeleteAnimation = BehaviorSubject<Bool>(value: false)
    
    // MARK: Public
    let drug: Drug
    weak var delegate: DrugCellModelDelegate?
    
    // MARK: Private
    private let cartManager: CartManagerType
    private let authManager: AuthManager
    private let drugStoreRepository: DrugStoreRepositoryType
    private var currentWarehouse: WarehouseInfo?
    private let bag = DisposeBag()
    
    init(drug: Drug, authManager: AuthManager, cartManager: CartManagerType, drugStoreRepository: DrugStoreRepositoryType) {
        // MARK: Static values
        self.drug = drug
        self.cartManager = cartManager
        self.drugStoreRepository = drugStoreRepository
        self.authManager = authManager
        
        self.titleText = drug.title
        self.manufacturerText = drug.manufacturer?.title ?? ""
        self.drugImageUrl = drug.getMainImageUrl()
        
        if let price = drug.price {
            let priceFormater = PriceFormater(price: price)
            self.currentCostText = priceFormater.currentCost
            self.oldCostText = priceFormater.oldCost
            self.discountText = priceFormater.discount
        } else {
            self.currentCostText = ""
        }
        
        switch drug.recipeType {
        case .simple:
            recipeStatus = .none
        case .recipe:
            recipeStatus = .recipe2
        case .strictlyRecipe:
            recipeStatus = .recipe
        }
        
        configureDrugstores()
        
        // MARK: Dynamic values
        cartManager.cart
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.configurePurchaseStatus()
            })
            .disposed(by: bag)
    }
    
    private func configurePurchaseStatus() {
        if let cartItem = cartManager.getDrug(id: drug.id) {
            purchaseStatus.onNext(.bought(count: cartItem.count))
        } else {
            purchaseStatus.onNext(.notBought)
        }
    }

    private func configureDrugstores() {
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            let drugStores = self.getCurrentDrugStore()
            
            if let warehouse = self.getCurentWarehouse(from: drugStores) {
                self.currentWarehouse = warehouse
                let addressesDict = self.getStoreAddressesDict(stores: drugStores)
                
                DispatchQueue.main.async {
                    self.allDrugStores.onNext(addressesDict)
                    self.currentDrugStoreId.onNext(warehouse.id)
                }
            } else {
                DispatchQueue.main.async {
                    self.disableView()
                }
            }
        }
    }
    
    private func getCurrentDrugStore() -> [DrugStore] {
        let allStores = drugStoreRepository.getAllDrugStores()
        let ids = drug.drugstores.map { $0.id }
        return allStores.filter({ ids.contains($0.id) })
    }
    
    private func disableView() {
        self.viewIsEnable.onNext(false)
        self.secondaryText.onNext("")
        let text = NSAttributedString(string: "Нет в наличии", attributes: [NSAttributedStringKey.foregroundColor: UIColor.taGray])
        self.allDrugStores.onNext([0: text])
    }
    
    private func getCurentWarehouse(from stores: [DrugStore]) -> WarehouseInfo? {
        guard stores.count > 0 else {
            return nil
        }
        
        var currentStoreId: Int? = AppConfiguration.shared.favoriteDrugStore.value?.id
        
        if let cartItem = cartManager.getDrug(id: drug.id) {
            currentStoreId = cartItem.drugstoreId
        }
        
        if let id = currentStoreId, let store = drug.drugstores.first(where: { $0.id == id }) {
            return store
        }
        
        return drug.drugstores.first(where: { $0.id == stores[0].id })
    }

    private func getStoreAddressesDict(stores: [DrugStore]) -> [Int: NSAttributedString] {
        var dictionary: [Int: NSAttributedString] = [:]
        
        for store in stores {
            if store.isWorkingToday() {
                dictionary[store.id] = NSAttributedString(string: store.address,
                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
                continue
            }
            
            let text = "\(store.address) \(store.getFreedayString() ?? "")"
            
            dictionary[store.id] = NSAttributedString(string: text,
                                                      attributes: [NSAttributedStringKey.foregroundColor: UIColor.taRed])
        }
        
        return dictionary
    }
    
    // MARK: - Actions
    
    func buyDrug() {
        guard authManager.currenUser != nil else {
            delegate?.showAuthorizationAlert()
            return
        }
        
        if drug.recipeType == .strictlyRecipe {
            delegate?.showRecipeAlert(successHandler: { [unowned self] in
                self.buyDrugAction()
            })
            return
        }
        
        buyDrugAction()
    }
    
    private func buyDrugAction() {
        guard let currentWarehouse = currentWarehouse else {
            return print("Not found selected drug store")
        }
        
        delegate?.showCount(min: 1, max: currentWarehouse.tradeCount) { [unowned self] count in
            self.isBuyAnimation.onNext(true)
            
            self.cartManager.add(id: self.drug.id, storeId: currentWarehouse.id, count: count)
                .subscribe(onCompleted: {
                    self.isBuyAnimation.onNext(false)
                    self.purchaseStatus.onNext(.bought(count: count))
                }, onError: { error in
                    self.isBuyAnimation.onNext(false)
                    self.delegate?.showError(error: error)
                }).disposed(by: self.bag)
        }
    }

    func changeCountDrug() {
        guard authManager.currenUser != nil else {
            delegate?.showAuthorizationAlert()
            return
        }
        
        guard let currentWarehouse = currentWarehouse else {
            return print("Not found selected drug store")
        }
        
        delegate?.showCount(min: 1, max: currentWarehouse.tradeCount) { [unowned self] count in
            guard self.cartManager.getDrug(id: self.drug.id)?.count != count else {
                return
            }
            
            self.isAddAnimation.onNext(true)
            
            self.cartManager.add(id: self.drug.id, storeId: currentWarehouse.id, count: count)
                .subscribe(onCompleted: { [unowned self] in
                    self.isAddAnimation.onNext(false)
                    self.purchaseStatus.onNext(.bought(count: count))
                }, onError: { [unowned self] error in
                    self.isAddAnimation.onNext(false)
                    self.delegate?.showError(error: error)
                }).disposed(by: self.bag)
        }
    }
    
    func deleteDrug() {
        guard authManager.currenUser != nil else {
            delegate?.showAuthorizationAlert()
            return
        }
        
        isDeleteAnimation.onNext(true)
        
        cartManager.delete(id: drug.id)
            .subscribe(onCompleted: { [unowned self] in
                self.isDeleteAnimation.onNext(false)
                self.purchaseStatus.onNext(.notBought)
            }, onError: { [unowned self] error in
                self.isDeleteAnimation.onNext(false)
                self.delegate?.showError(error: error)
            }).disposed(by: bag)
    }
    
    func changeDrugStore(id selectedStoreId: Int) {
        guard currentWarehouse?.id != selectedStoreId else {
            return
        }
    
        currentWarehouse = drug.drugstores.first(where: { $0.id == selectedStoreId })!
        
        if cartManager.getDrug(id: drug.id) != nil {
            guard authManager.currenUser != nil else {
                delegate?.showAuthorizationAlert()
                return
            }
            
            let drugCount = 1
            isAddAnimation.onNext(true)
            
            cartManager.add(id: drug.id, storeId: currentWarehouse!.id, count: drugCount)
                .subscribe(onCompleted: { [unowned self] in
                    self.isAddAnimation.onNext(false)
                    self.purchaseStatus.onNext(.bought(count: drugCount))
                }, onError: { error in
                    self.isAddAnimation.onNext(false)
                    self.delegate?.showError(error: error)
                }).disposed(by: bag)
            
            return
        }
    }
    
    deinit {
        //print("Deinit cell model")
    }
    
}
