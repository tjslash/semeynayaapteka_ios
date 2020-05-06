//
//  IntroPage.swift
//  TvoyaApteka
//
//  Created by Василий Новичихин on 16/03/2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift

protocol OnBoardingViewControllerDelegate: class {
    func finishShowing()
}

class OnBoardingViewController: BaseViewController {
    
    let bug = DisposeBag()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.bounces = false
        scroll.delegate = self
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = UIColor.taPrimary
        pageControl.pageIndicatorTintColor = UIColor.taLightPrimary
        return pageControl
    }()
    
    var nextButton = ActionButton(title: "Далее".uppercased())
    
    var slides: [OnBoardingView] = []
    
    var nextPage: Int {
        guard pageControl.currentPage < slides.count else { return pageControl.currentPage }
        return pageControl.currentPage + 1
    }
    
    weak var delegate: OnBoardingViewControllerDelegate?
    
    private let pages = Variable<[OnBoardingViewModel]>([])
    private let pagesCount = Variable<Int>(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUI()
        binding()
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-48)
            make.width.equalTo(280)
            make.height.equalTo(48)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-24)
        }
        
        view.layoutIfNeeded()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    private func createSlides() -> [OnBoardingViewModel] {
        return [
            OnBoardingViewModel(image: "OnBoarding1", text: "Бронируйте аптечные товары по выгодной цене."),
            OnBoardingViewModel(image: "OnBoarding2", text: "Выбирайте удобную аптеку и забирайте свой заказ без очереди."),
            OnBoardingViewModel(image: "OnBoarding3", text: "Подписывайтесь на наши социальные сети и участвуйте в розыгрышах.")
        ]
    }
    
    func binding() {
        pages.value = createSlides()
        
        pages.asObservable()
            .map { return $0.count }
            .bind(to: pagesCount)
            .disposed(by: bug)
        
        pages.asObservable()
            .bind { [unowned self] models in self.uploadSliders(for: models) }
            .disposed(by: bug)
        
        pagesCount.asObservable()
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: bug)
        
        nextButton.rx.tap.asObservable()
            .bind { [unowned self] in
                if self.pageControl.isLastPage {
                    self.delegate?.finishShowing()
                } else {
                    self.scroll(to: self.nextPage)
                }
            }.disposed(by: bug)
    }
    
    private func uploadSliders(for models: [OnBoardingViewModel]) {
        for model in models {
            let slide = OnBoardingView()
            slide.viewModel = model
            slides.append(slide)
        }
        
        updateScrollView()
    }
    
    private func updateScrollView() {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(slides.count), height: UIScreen.main.bounds.height)
        
        for (index, slide) in slides.enumerated() {
            slide.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index),
                                 y: 0,
                                 width: UIScreen.main.bounds.width,
                                 height: UIScreen.main.bounds.height)
            scrollView.addSubview(slide)
        }
    }
    
    private func scroll(to page: Int) {
        let xPosition = CGFloat(page) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: xPosition, y: 0), animated: true)
    }
    
    func nextView(_ view: String) {
        
    }
    
}

// MARK: UIScrollViewDelegate
extension OnBoardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
}
