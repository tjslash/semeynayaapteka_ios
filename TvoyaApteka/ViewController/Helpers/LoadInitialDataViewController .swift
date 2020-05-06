//
//  LoadInitialDataViewController .swift
//  TvoyaApteka
//
//  Created by BuidMac on 06.08.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import Foundation
import RxSwift

class LoadInitialDataViewController: BaseViewController {
    
    private let completionHandler: (() -> Void)
    private let userCity: City
    private let bag = DisposeBag()
    
    init(_ userCity: City, completion handler: @escaping () -> Void) {
        self.userCity = userCity
        self.completionHandler = handler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPreloader()
        uploadData()
    }
   
    func uploadData() {
        DrugStoreRepository().cached(for: userCity)
            .subscribe(onCompleted: { [weak self] in
                self?.completionHandler()
            }, onError: { [weak self] error in
                self?.handleError(error)
            })
            .disposed(by: bag)
    }
    
    override func handleError(_ error: Error) {
        guard let serviceError = error as? ServiceError else {
            super.handleError(error)
            return
        }
        
        switch serviceError {
        case .noConnectionToServer:
            let childViewController = NotConnectionViewController(reconectCallback: { [weak self] in
                self?.uploadData()
            })
            
            add(childViewController)
        default:
            super.handleError(error)
        }
    }
    
}
