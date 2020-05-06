//
//  ReviewCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReviewCoordinatorDelegate: class {
    func finishFlow(coordinator: ReviewCoordinator)
}

class ReviewCoordinator: BaseCoordinator {
    
    // MARK: Public
    public weak var delegate: ReviewCoordinatorDelegate?
    
    // MARK: Private
    private let feedBackRepository: FeedBackRepositoryType = FeedBackRepository()
    private let user: AuthUserType?
    private let bag = DisposeBag()
    
    init(router: RouterType, user: AuthUserType?) {
        self.user = user
        super.init(router: router)
    }
    
    required public init(router: RouterType) {
        fatalError("init(router:) has not been implemented")
    }
    
    override func start() {
        showReviewPage(for: user)
    }
    
    private func showReviewPage(for user: AuthUserType?) {
        let viewModel = CreateReviewViewModel(user: user, repository: feedBackRepository)
        let page = CreateReviewViewController(viewModel: viewModel)
        page.delegate = self
        router.push(page, animated: true, completion: { [unowned self] in self.delegate?.finishFlow(coordinator: self) })
    }
    
}
