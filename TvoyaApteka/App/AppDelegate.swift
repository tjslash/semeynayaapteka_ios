//
//  AppDelegate.swift
//  TvoyaApteka
//
//  Created by BuidMac on 15.03.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit
import RxSwift
import YandexMapKit
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootCoordinator: BaseCoordinator!
    private let bag = DisposeBag()
    private let authManager: AuthManagerType = AuthManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DefaultTheme.apply()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForRemoteNotifications(application)
        
        YMKMapKit.setApiKey(Const.mapKey)
        
        showFirstPage()
        return true
    }
    
    private func showFirstPage() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        let router = Router(navigationController: navigationController)
        rootCoordinator = RootCoordinator(router: router)
        rootCoordinator.start()
    }
    
    private func registerForRemoteNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        if application.applicationState != .active {
//            handleRemoteNotification(with: userInfo)
//        }
//
//        completionHandler(.noData)
//    }
//
//    private func handleRemoteNotification(with userInfo: [AnyHashable: Any]) {
//        guard let dict = userInfo as? [String: AnyObject] else { return }
//        let deepLink = DeepLinkManager.build(with: dict)
//        rootCoordinator.start(with: deepLink)
//    }
    
}

// MARK: UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {

//    @available(iOS 10.0, *)
//    // swiftlint:disable line_length
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        // swiftlint:enable line_length
//        completionHandler(UNNotificationPresentationOptions.alert)
//    }

}

// MARK: MessagingDelegate
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        authManager.currenUser?
            .getToken()
            .flatMapCompletable({ token in
                ServerAPI.deviceToken.send(token: token, pushToken: fcmToken)
            })
            .subscribe()
            .disposed(by: bag)
    }
    
}
