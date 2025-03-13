//
//  AppRouter.swift
//  Shoppe
//
//  Created by Николай Игнатов on 12.03.2025.
//

import UIKit

protocol AppRouterProtocol {
    func start()
    func dismiss(animated: Bool)
    func showStartScreen()
    func showRegistrationScreen()
    func showLoginScreen()
    func showMainTabBar()
}

final class AppRouter: AppRouterProtocol {
    var navigation: UINavigationController
    var window: UIWindow?
    
    init(navigation: UINavigationController, window: UIWindow?) {
        self.navigation = navigation
        self.window = window
    }
    
    func start() {
        configureWindow()
        startInitialViewController()
    }
    
    func dismiss(animated: Bool) {
        navigation.dismiss(animated: animated)
    }
    
    func showStartScreen() {
        let startViewController = StartFactory.makeModule(router: self)
        navigation.viewControllers = [startViewController]
    }
    
    func showRegistrationScreen() {
        let registrationViewController = RegistrationFactory.makeModule(router: self)
        registrationViewController.modalPresentationStyle = .fullScreen
        presentModalViewController(registrationViewController)
    }
    
    func showLoginScreen() {
        let loginViewController = LoginFactory.makeModule(router: self)
        loginViewController.modalPresentationStyle = .fullScreen
        presentModalViewController(loginViewController)
    }
    
    func showMainTabBar() {
        let tabBarController = MainTabBarFactory.makeModule(router: self)
        
        let completion: () -> Void = { [weak self] in
            self?.navigation.setViewControllers([tabBarController], animated: true)
        }
        
        if let presentedViewController = navigation.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: completion)
        } else {
            completion()
        }
    }
}

private extension AppRouter {
    func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigation.pushViewController(viewController, animated: animated)
    }
    
    func presentModalViewController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        navigation.present(viewController, animated: animated, completion: completion)
    }
    
    private func configureWindow() {
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
    
    private func startInitialViewController() {
        navigation.navigationBar.isHidden = true
        if true {
            showStartScreen()
        }
    }
}
