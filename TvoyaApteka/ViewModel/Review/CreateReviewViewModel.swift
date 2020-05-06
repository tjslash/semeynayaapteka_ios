//
//  CreateReviewViewModel.swift
//  TvoyaApteka
//
//  Created by BuidMac on 30.07.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CreateReviewViewModel {
    
    // MARK: Input
    let name = Variable<String?>(nil)
    let phone = Variable<String?>(nil)
    let feedBack = Variable<String?>(nil)
    let sendFeedBackButtonDidTap = PublishSubject<Void>()
    
    // MARK: Output
    let phoneIsHidden: Bool
    let errorMessage = PublishSubject<String>()
    let sendFeedBackButtonIsEnable: Driver<Bool>
    let sendFeedBackSuccess = PublishSubject<Void>()
    let sendFeedBackError = PublishSubject<Error>()
    
    // MARK: Private
    private let repository: FeedBackRepositoryType
    private let errorFabric = ErrorMessageFabric()
    private let activityIndicator = ActivityIndicator()
    private let bag = DisposeBag()
    
    init(user: AuthUserType?, repository: FeedBackRepositoryType) {
        self.repository = repository
        self.name.value = user?.info.firstName ?? "Гость"
        
        let phoneNum = user?.info.phoneNumber
        self.phone.value = phoneNum
        self.phoneIsHidden = (phoneNum != nil)
    
        let formIsValid = Driver.combineLatest(feedBack.asDriver(), phone.asDriver()) { feedBack, phone -> Bool in
            guard let feedBack = feedBack, let phone = phone else {
                return false
            }
            
            return !feedBack.isEmpty && !phone.isEmpty
        }
        
        sendFeedBackButtonIsEnable = Driver.combineLatest(activityIndicator.asDriver(), formIsValid) { isLoading, isValidForm -> Bool in
            return isLoading == false && isValidForm == true
        }
        
        sendFeedBackButtonDidTap
            .withLatestFrom(formIsValid)
            .filter({ $0 == true })
            .bind(onNext: { [weak self] _ in
                guard let phone = self?.phone.value, let text = self?.feedBack.value, let name = self?.name.value else { return }
                self?.sendFeedBack(phone: phone, name: name, text: text)
            })
            .disposed(by: bag)
    
    }
    
    private func sendFeedBack(phone: String, name: String, text: String) {
        repository.sendFeedback(phone: phone, text: text, name: name)
            .trackActivity(activityIndicator)
            .asCompletable()
            .subscribe(
                onCompleted: { [weak self] in
                    self?.sendFeedBackSuccess.onNext(())
                }, onError: { [weak self] error in
                    self?.handleError(error)
            }).disposed(by: bag)
    }
    
    private func handleError(_ error: Error) {
        if let textError = errorFabric.getMessage(form: error) {
            errorMessage.onNext(textError)
        }
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
