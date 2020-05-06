//
//  MapPage.swift
//  TvoyaApteka
//
//  Created by BuidMac on 10.04.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import SnapKit
import YandexMapKit

class DrugStoresOnMapViewController: BaseViewController, YMKMapObjectTapListener {

    private let mapView = YMKMapView()
    
    private var map: YMKMap? {
        return mapView.mapWindow.map
    }
    
    private var stores: [DrugStore] = []
    
    init(stores: [DrugStore]) {
        self.stores = stores
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .taAlmostWhite
        setupLayout()
        setupMap()
    }
    
    private func setupMap() {
        map?.isDebugInfoEnabled = true
        
        if let map = map {
            let configurator = MapConfigurator(map: map, builder: StoreAnnotationBuilder<DrugStore>(stores: stores))
            configurator.tapListener = self
            configurator.updateMap()
        }

        // Разкомментируй строки для отображения позиции пользовтеля
        // Настрой иконку в методе onObjectAdded
        
//        setupUserPosition()
    }
    
//    private func setupUserPosition() {
//        let scale = UIScreen.main.scale
//        let userLocationLayer = mapView.mapWindow.map!.userLocationLayer
//        userLocationLayer!.isEnabled = true
//        userLocationLayer!.isHeadingEnabled = true
//        userLocationLayer!.setAnchorWithAnchorNormal(
//            CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.5 * mapView.frame.size.height * scale),
//            anchorCourse: CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.83 * mapView.frame.size.height * scale))
//        userLocationLayer!.setObjectListenerWith(self)
//    }
    
    private func setupLayout() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-20)
        }
    }
    
    func onMapObjectTap(with mapObject: YMKMapObject?, point: YMKPoint) -> Bool {
        if let store = mapObject?.userData as? DrugStore {
            showInfo(store)
            return true
        }
        
        return false
    }
    
    private func showInfo(_ store: DrugStore) {
        let viewController = StoreInfoAlert(store: store)
        
        viewController.didTapButton = { [unowned self] in
            viewController.dismiss(animated: false) {
                let viewModel = DrugStoreDetailsViewModel(storeId: store.id, drugStoreRepository: DrugStoreRepository())
                let viewController = DrugStoreDetailsViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: true, completion: nil)
    }

}

// MARK: YMKUserLocationObjectListener
//extension MapPage: YMKUserLocationObjectListener {
//
//    func onObjectAdded(with view: YMKUserLocationView?) {
//        view!.pin!.setIconWith(#imageLiteral(resourceName: "Back"))
//        view!.arrow!.setIconWith(#imageLiteral(resourceName: "Back"))
//        view!.accuracyCircle!.fillColor = UIColor.blue
//    }
//
//    func onObjectRemoved(with view: YMKUserLocationView?) {
//
//    }
//
//    func onObjectUpdated(with view: YMKUserLocationView?, event: YMKObjectEvent?) {
//
//    }
//
//}
