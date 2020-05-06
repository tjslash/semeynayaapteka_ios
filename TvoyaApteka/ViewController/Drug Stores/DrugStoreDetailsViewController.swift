//
//  StoreDescriptionPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 16.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift
import YandexMapKit

class DrugStoreDetailsViewController: ScrollViewController {
    
    private let storeInfoView = StoreInfoView()
    private let storeImageView = UIImageView()
    
    private let mapView: YMKMapView = {
        let map = YMKMapView()
        map.isUserInteractionEnabled = false
        return map
    }()
    
    private var map: YMKMap? {
        return mapView.mapWindow.map
    }
    
    private let viewModel: DrugStoreDetailsViewModel
    private let bag = DisposeBag()
    
    weak var delegate: BaseViewControllerDelegate?
    
    init(viewModel: DrugStoreDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Расположение аптеки"
        view.backgroundColor = .taAlmostWhite
        addSearchBarButton()
        binding()
        viewModel.uploadStore()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        let visualStackView = UIStackView(arrangedSubviews: [storeImageView, mapView])
        visualStackView.axis = .vertical
        visualStackView.spacing = 0
        
        mapView.snp.makeConstraints { make in
            make.height.equalTo(350)
        }
        
        let mainStackView = UIStackView(arrangedSubviews: [storeInfoView, visualStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        
        contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.bottom.lessThanOrEqualToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func binding() {
        viewModel.errorMessage
            .bind(to: self.rx.showMessage)
            .disposed(by: bag)
        
        viewModel.isUploading
            .drive(self.rx.showPreloader)
            .disposed(by: bag)
        
        viewModel.store
            .bind(onNext: { [unowned self] store in
                self.setModel(store: store)
            })
            .disposed(by: bag)
    }
    
    override func searchButtonHandler() {
        delegate?.didSelectSearch()
    }

    private func setModel(store: DrugStore) {
        storeInfoView.nameTitleLabel.text = store.title
        storeInfoView.addressLabel.text = store.address
        storeInfoView.scheduleLabel.text = store.getScheduleString()
        
        if let url = store.getMainImageUrl() {
            setupImageView(url: url)
        }
        
        updateMap(for: store)
    }
    
    private func updateMap(for store: DrugStore) {
        if let map = self.map {
            let configurator = MapConfigurator(map: map, builder: StoreAnnotationBuilder<DrugStore>(stores: [store]))
            configurator.updateMap()
        }
    }
    
    private func setupImageView(url: URL) {
        storeImageView.setAsyncImage(url: url, placeholder: nil) { [unowned self] image, _ in
            if let image = image {
                self.storeImageView.snp.makeConstraints { make in
                    make.height.equalTo(self.storeImageView.snp.width).multipliedBy(image.size.height / image.size.width)
                }
                
                self.view.layoutSubviews()
            }
        }
    }
    
}

private class StoreInfoView: UIView {
    
    var nameTitleLabel = TitleHeaderCellLabel()
    
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h4
        return label
    }()
    
    var scheduleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Title.h4
        label.textColor = UIColor.taGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let descriptionStackView = UIStackView(arrangedSubviews: [addressLabel, scheduleLabel])
        descriptionStackView.axis = .vertical
        descriptionStackView.spacing = 13
        
        let mainStackView = UIStackView(arrangedSubviews: [nameTitleLabel, lineView, descriptionStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        
        addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
}
