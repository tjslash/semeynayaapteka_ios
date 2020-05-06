//
//  UIViewController+Alert.swift
//  TvoyaApteka
//
//  Created by BuidMac on 18.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func showAuthorizationAlert(cancelAction cancelActionHandler: (() -> Void)? = nil, doneAction doneActionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: nil, message: "Что бы продолжить, необходимо авторизоваться", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена".uppercased(), style: .cancel) { _ in
            cancelActionHandler?()
        }
        
        let doneAction = UIAlertAction(title: "Войти".uppercased(), style: .default) { _ in
            doneActionHandler?()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
    }
    
    public func showPrescriptionDrugAlert(completion: (() -> Void)? = nil) {
        let alert = PrescriptionDrugAlert()
        alert.titleText = "Добавления\nстрогорецептурного товара"
        alert.descriptionText = "Продажа товара осуществляется \nтолько при наличии рецепта \nпо форме 107-1/у"
        alert.didTapDone = completion
        presentAsAlert(alert, completion: nil)
    }
    
    private func presentAsAlert(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)?) {
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.modalPresentationCapturesStatusBarAppearance = true
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: animated, completion: completion)
    }
    
}
