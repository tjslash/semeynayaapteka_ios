//
//  Router.swift
//  TvoyaApteka
//
//  Created by BuidMac on 28.05.2018.
//  Copyright © 2018 Tematika. All rights reserved.
//

import UIKit

public protocol RouterType: class, Presentable {
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }
    var visibleViewController: UIViewController? { get }
    func present(_ module: Presentable, animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
    func popModule(animated: Bool)
    func setRootModule(_ module: Presentable, hideBar: Bool)
    func popToRootModule(animated: Bool)
}

final public class Router: NSObject, RouterType {
    
    public func toPresentable() -> UIViewController {
        return navigationController
    }
    
    private var completions: [UIViewController : () -> Void]
    
    public var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }
    
    public var visibleViewController: UIViewController? {
        return navigationController.visibleViewController
    }
    
    public var hasRootController: Bool {
        return rootViewController != nil
    }
    
    public let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        self.completions = [:]
        super.init()
        self.navigationController.delegate = self
    }
    
    public func present(_ module: Presentable, animated: Bool = true) {
        navigationController.present(module.toPresentable(), animated: animated, completion: nil)
    }
    
    public func dismissModule(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    public func push(_ module: Presentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        let controller = module.toPresentable()
        
        guard controller is UINavigationController == false else {
            fatalError("Avoid pushing UINavigationController onto stack")
        }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func popModule(animated: Bool = true) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    public func setRootModule(_ module: Presentable, hideBar: Bool = false) {
        // Call all completions so all coordinators can be deallocated
        completions.forEach { $0.value() }
        navigationController.setViewControllers([module.toPresentable()], animated: false)
        navigationController.isNavigationBarHidden = hideBar
    }
    
    public func popToRootModule(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
}

// MARK: UINavigationControllerDelegate
extension Router: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController) else {
                return
        }
        
        runCompletion(for: poppedViewController)
    }
    
}
