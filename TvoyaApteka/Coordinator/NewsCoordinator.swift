//
//  NewsCoordinator.swift
//  TvoyaApteka
//
//  Created by BuidMac on 29.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation

protocol NewsCoordinatorDelegate: class {
    func finishFlow(coordinator: NewsCoordinator)
}

class NewsCoordinator: BaseCoordinator {
    
    // MARK: Public
    public weak var delegate: NewsCoordinatorDelegate?
    
    // MARK: Private
    private let appConfiguration = AppConfiguration.shared
    private let articleRepository = ArticleRepository()
    
    override func start() {
        showListNewsPage()
    }
    
    private func showListNewsPage() {
        let viewModel = ListArticlesViewModel(repository: articleRepository)
        let viewController = ListArticlesViewController(viewModel: viewModel)
        viewController.delegate = self
        router.push(viewController, animated: true, completion: { [unowned self] in self.delegate?.finishFlow(coordinator: self) })
    }
    
    private func showNewDetailsPage(id: Int) {
        let viewModel = ArticleDetailsViewModel(id: id, userCity: appConfiguration.currentCity!, repository: articleRepository)
        let viewController = ArticleDetailsViewController(viewModel: viewModel)
        viewController.delegate = self
        router.push(viewController, animated: true, completion: nil)
    }
    
}

// MARK: ListNewsPageDelegate
extension NewsCoordinator: ListArticlesViewControllerDelegate {
    
    func selectArticle(id: Int) {
        showNewDetailsPage(id: id)
    }
    
}
