//
//  ListNewsPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 11.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift

protocol ListArticlesViewControllerDelegate: BaseViewControllerDelegate {
    func selectArticle(id: Int)
}

class ListArticlesViewController: BaseViewController {
    
    public weak var delegate: ListArticlesViewControllerDelegate?
    
    private var articles: [Article] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView = UITableView.tableView
    private let refreshControll = UIRefreshControl()
    private let viewModel: ListArticlesViewModel
    private let bag = DisposeBag()
    
    init(viewModel: ListArticlesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = UIColor.taAlmostWhite
        title = "Полезная информация"
        addSearchBarButton()
        setupTableView()
        binding()
        viewModel.uploadArticles()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControll
        } else {
            tableView.addSubview(refreshControll)
        }
        
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    private func binding() {
        refreshControll.rx.controlEvent(.valueChanged)
            .bind(onNext: { [unowned self] in
                self.viewModel.refreshArticles()
            })
            .disposed(by: bag)
        
        viewModel.isRefreshing
            .drive(refreshControll.rx.isRefreshing)
            .disposed(by: bag)
        
        viewModel.articles
            .asDriver()
            .drive(onNext: { [unowned self] articles in
                self.articles = articles
            })
            .disposed(by: bag)
        
        viewModel.isUploadData
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.isLoadingMore
            .drive(tableView.rx.bottonRefresingIsVisible)
            .disposed(by: bag)
        
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
    }
    
}

// MARK: - UITableView
extension ListArticlesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            viewModel.loadMore()
        }
    }
    
}

// MARK: UITableView
extension ListArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = (articles.count != 0)
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ArticlesAnnotationCell
        let article = articles[indexPath.row]
        
        cell.titleText = article.title
        cell.dateText = article.date.toString(withFormat: .dateText)
        cell.descriptionText = article.announce
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard articles.indices.contains(indexPath.row) else { return }
        delegate?.selectArticle(id: articles[indexPath.row].id)
    }
    
}

// MARK: Static UITableView fabric
private extension UITableView {
    
    static var tableView: UITableView {
        let tableView = UITableView()
        tableView.register(ArticlesAnnotationCell.self, forCellReuseIdentifier: ArticlesAnnotationCell.identifier)
        tableView.rowHeight = 165
        tableView.estimatedRowHeight = 165
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.backgroundView = EmptyListView()
        return tableView
    }
    
}
