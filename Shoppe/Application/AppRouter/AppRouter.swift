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
    func popViewController(animated: Bool)
    func showStartScreen()
    func showRegistrationScreen()
    func showLoginScreen()
    func showMainTabBar()
    func showOnboarding()
    func showSearch()
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
    
    func popViewController(animated: Bool) {
        navigation.popViewController(animated: animated)
    }
    
    func showStartScreen() {
        let startViewController = AppFactory.makeStartModule(router: self)
        navigation.viewControllers = [startViewController]
    }
    
    func showRegistrationScreen() {
        let registrationViewController = AppFactory.makeRegistrationModule(router: self)
        registrationViewController.modalPresentationStyle = .fullScreen
        presentModalViewController(registrationViewController)
    }
    
    func showLoginScreen() {
        let loginViewController = AppFactory.makeLoginModule(router: self)
        loginViewController.modalPresentationStyle = .fullScreen
        presentModalViewController(loginViewController)
    }
    
    func showOnboarding() {
        let onboardingViewController = AppFactory.makeOnboardingModule(router: self)
        onboardingViewController.modalPresentationStyle = .fullScreen
        navigation.presentedViewController?.dismiss(animated: false)
        presentModalViewController(onboardingViewController)
    }
    
    func showSearch() {
        let searchViewController = AppFactory.makeSearchModule(router: self)
        pushViewController(searchViewController)
    }
    
    func showMainTabBar() {
        let tabBarController = AppFactory.makeTabBarModule(router: self)
        
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
        navigation.navigationBar.isHidden = true
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
    
    private func startInitialViewController() {
        let user: User? = UserDefaultsService.shared.getCustomObject(forKey: .userModel)
        let isUserAuthorised = user?.isAuthorized ?? false
      
        switch isUserAuthorised {
        case true: showMainTabBar()
        case false: showStartScreen()
        }
    }
}
