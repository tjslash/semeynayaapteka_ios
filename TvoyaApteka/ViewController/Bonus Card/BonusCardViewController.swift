//
//  BonusCardPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 18.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class BonusCardViewController: ScrollViewController {
    
    private let user: AuthUserType
    private let bag = DisposeBag()
    private let bonusCardRepository: BonusCardRepositoryType = BonusCardRepository()
    
    weak var delegate: BaseViewControllerDelegate?
    
    init(user: AuthUserType) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBarButton()
        title = "Дисконтная карта"
        view.backgroundColor = UIColor.taAlmostWhite
        showPreloader()
        uploadCardInfo()
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    private func uploadCardInfo() {
        bonusCardRepository.getBonusCard(for: user)
            .subscribe(onSuccess: { [unowned self] bonusCard in
                self.showAciveCardView(bonusCard: bonusCard)
                self.hidePreloader()
            }, onError: { [unowned self] error in
                self.hidePreloader()
                self.handleError(error)
            }).disposed(by: bag)
    }
    
    private func showAciveCardView(bonusCard: BonusCard) {
        let activeCard = BonusCardActiveView(bonusCard: bonusCard)
        
        activeCard.aboutBonusProgrammAction = { [unowned self] in
            self.showWebPage(url: Const.Url.bonusProgramm)
        }

        activeCard.showAllHistoryAction = { [unowned self] in
            let page = HistoryOperationsViewController(user: self.user)
            self.navigationController?.pushViewController(page, animated: true)
        }
        
        showView(activeCard)
    }
    
    private func showNotAciveCardView() {
        let notActiveCard = BonusCardNotActiveView()
        addDoneToolBar(textField: notActiveCard.bonusCardView.cardNumbField)
        
        notActiveCard.aboutBonusProgrammAction = { [unowned self] in
            self.showWebPage(url: Const.Url.bonusProgramm)
        }
        
        notActiveCard.activateBonusCardAction = { [weak self] num in
            guard let strongSelf = self else { return }
            
            strongSelf.showPreloader()
            
            strongSelf.bonusCardRepository.activeBonusCard(for: strongSelf.user, num: num)
                .andThen(strongSelf.bonusCardRepository.getBonusCard(for: strongSelf.user))
                .subscribe(onSuccess: { bonusCard in
                        strongSelf.showAciveCardView(bonusCard: bonusCard)
                        strongSelf.hidePreloader()
                    }, onError: { error in
                        strongSelf.handleError(error)
                        strongSelf.hidePreloader()
                }).disposed(by: strongSelf.bag)
        }
        
        showView(notActiveCard)
    }
    
    override func handleError(_ error: Error) {
        guard let serviceError = error as? ServiceError else {
            super.handleError(error)
            return
        }
        
        switch serviceError {
        case .notFound:
            showNotAciveCardView()
        default:
            super.handleError(error)
        }
    }
    
    private func showView(_ view: UIView) {
        for subView in contentView.subviews {
            subView.removeFromSuperview()
        }
        
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    private func showWebPage(url: URL) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
