//
//  DetailNewsPage.swift
//  TvoyaApteka
//
//  Created by oleg shkreba on 03.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

class ArticleDetailsViewController: ScrollViewController {
    
    private let titleLabel = UILabel.titleLabel
    private let dateLabel = UILabel.dateLabel
    private let newsImageView = UIImageView.newsImageView
    private let descriptionTextView = UITextView.descriptionTextView
    
    private let viewModel: ArticleDetailsViewModel
    private let bag = DisposeBag()
    
    weak var delegate: BaseViewControllerDelegate?
    
    init(viewModel: ArticleDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBarButton()
        view.backgroundColor = .taAlmostWhite
        binding()
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }

    override func setupLayout() {
        super.setupLayout()
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel, newsImageView, descriptionTextView])
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.alignment = .leading
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.lessThanOrEqualToSuperview().offset(-22)
        }
    }
    
    private func binding() {
        viewModel.isUpoadData
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.article
            .bind(onNext: { [unowned self] article in
                self.updatePage(article: article)
            })
            .disposed(by: bag)
        
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
    }
    
    private func updatePage(article: Article) {
        titleLabel.text = article.title
        dateLabel.text = article.date.toString(withFormat: .dateText)
        descriptionTextView.setHTML(text: article.content, font: descriptionTextView.font!, color: descriptionTextView.textColor)
        title = article.title
        
        if let url = article.getMainImageUrl() {
            self.setupImageView(url: url)
        }
    }
    
    private func setupImageView(url: URL) {
        newsImageView.setAsyncImage(url: url, placeholder: nil) { [weak self] image, _ in
            guard let strongSelf = self else { return }
            
            if let image = image {
                strongSelf.newsImageView.snp.makeConstraints { make in
                    make.height.equalTo(strongSelf.newsImageView.snp.width).multipliedBy(image.size.height / image.size.width)
                }
                
                strongSelf.view.layoutSubviews()
            }
        }
    }
    
}

// MARK: Static UILabel fabric
private extension UILabel {
    
    static var titleLabel: UILabel {
        let label = Label()
        label.font = UIFont.Title.h2Bold
        label.textColor = .taBlack
        label.numberOfLines = 0
        return label
    }
    
    static var dateLabel: UILabel {
        let label = Label()
        label.font = UIFont.Title.h4
        label.textColor = .taGray
        return label
    }
    
}

// MARK: Static UIImageView fabric
private extension UIImageView {
    
    static var newsImageView: UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        return imageView
    }
    
}

// MARK: Static UITextView fabric
private extension UITextView {
    
    static var descriptionTextView: UITextView {
        let textView = UITextView()
        textView.font = UIFont.Title.h4
        textView.textColor = .taBlack
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }
    
}
