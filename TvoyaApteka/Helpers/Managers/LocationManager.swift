//
//  LocationManager.swift
//  TvoyaApteka
//
//  Created by Marty McFly on 18.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import CoreLocation
import UIKit
import RxSwift

class LocationManager: UIViewController {
    
    private let locationManager = CLLocationManager()
    let lastLocation = Variable<CLLocation?>(nil)
    
    func getLastLocation() -> CLLocation? {
        return lastLocation.value
    }
    
    func tryToStartGpsService() {
        locationManager.delegate = self
        
        if !isUserAlreadyMakeGpsDecision() {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if isUserBlockedGps() {
//            showAlert()
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func stopGpsService() {
        locationManager.stopUpdatingLocation()
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Сервис местоположения недоступен",
            message: "Пожалуйста включите службу местоположения в настройках",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        return
    }
    
    private func isUserAlreadyMakeGpsDecision() -> Bool {
        return CLLocationManager.authorizationStatus() != .notDetermined
    }
    
    private func isUserBlockedGps() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .denied || status == .restricted
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if isUserAlreadyMakeGpsDecision() && !isUserBlockedGps() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLoc = locations.last else { return }
        lastLocation.value = lastLoc
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
