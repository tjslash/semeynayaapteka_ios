//
//  DrugSliderView.swift
//  TvoyaApteka
//
//  Created by BuidMac on 23.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit

public class DrugSliderView: UIView {
    
    // MARK: Public API
    
    /// Set tint collor for slider (setup title color and page indicator color)
    override public var tintColor: UIColor! {
        didSet {
            titleLabel.textColor = tintColor
            slideIndicator.pageIndicatorTintColor = tintColor.withAlphaComponent(0.4)
            slideIndicator.currentPageIndicatorTintColor = tintColor
        }
    }
    
    /// Hide content without title lable
    public var contentIsHidden: Bool = false {
        didSet {
            collectionView.isHidden = contentIsHidden
            slideIndicator.isHidden = contentIsHidden
        }
    }
    
    /// Empty view will showing when coutDrugs is 0, by default is nil
    public var emptyView = UIView()

    /// Set count sliders's items
    public var countCells: Int = 0
    
    /// Called every time a cell is will display
    public var configureCellForRow: ((_ cell: DrugCardCollectionViewCell, _ indexPath: IndexPath) -> DrugCardCollectionViewCell)?
    
    /// Called every time a when cell was selected
    public var didSelect: ((_ indexPath: IndexPath) -> Void)?
    
    /// Reload slider
    public func reload() {
        collectionView.reloadData()
    }
    
    // MARK: Private API
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h2Bold
        label.textColor = .taPrimary
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.register(DrugCardCollectionViewCell.self, forCellWithReuseIdentifier: DrugCardCollectionViewCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = true
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private let slideIndicator: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 3
        control.numberOfPages = 3
        control.pageIndicatorTintColor = UIColor.taPrimary.withAlphaComponent(0.4)
        control.currentPageIndicatorTintColor = .taPrimary
        return control
    }()
    
    public init(title: String) {
        self.titleLabel.text = title
        super.init(frame: .zero)
        self.backgroundColor = .clear
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private struct SpacingRules {
        static let contentLeftOffset: CGFloat = 16
        static let collectionHeight: CGFloat = Const.drugCellHeight
    }
    
    // Я не стал удалять полностью слайдер, потмоу что есть ощущение, что придется вернуться к старой реализации и просто доработать ее.
    // Если изменений нет долгое время, можешь удалить полностью slideIndicator из этого файла
    // Если решите вернутся с реализации со slideIndicator, не забудь удалить в коде верхний отступ от DrugSliderView
    // Правка сделана 26.06.2018
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(collectionView)
//        addSubview(slideIndicator)

        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SpacingRules.contentLeftOffset)
            make.right.top.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(SpacingRules.contentLeftOffset)
            make.height.equalTo(SpacingRules.collectionHeight)
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }

//        slideIndicator.snp.makeConstraints { make in
//            make.top.equalTo(collectionView.snp.bottom)
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
    }
    
    private func setupLayoutEmptyView() {
        insertSubview(emptyView, aboveSubview: collectionView)
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(collectionView)
        }
    }
    
}

extension DrugSliderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if countCells == 0 {
            setupLayoutEmptyView()
        } else {
            emptyView.removeFromSuperview()
        }
        return countCells
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as DrugCardCollectionViewCell
        
        if let customConfigure = configureCellForRow {
            return customConfigure(cell, indexPath)
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(indexPath)
    }
    
}
