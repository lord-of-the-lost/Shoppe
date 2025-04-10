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
    func popToRoot()
    func showStartScreen()
    func showRegistrationScreen()
    func showLoginScreen()
    func showMainTabBar()
    func showOnboarding()
    func showSearch(context: SearchContext)
    func showProductDetail(_ product: Product)
    func showPaymentView()
    func showLocationMap()
    func showCategoriesTabBarItem()
    func showCartTabBarItem()
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
    
    func popToRoot() {
        navigation.popToRootViewController(animated: true)
    }
    
    func showStartScreen() {
        let startViewController = AppFactory.makeStartModule(router: self)
        navigation.viewControllers = [startViewController]
    }
    
    func showRegistrationScreen() {
        let registrationViewController = AppFactory.makeRegistrationModule(router: self)
        pushViewController(registrationViewController)
    }
    
    func showLoginScreen() {
        let loginViewController = AppFactory.makeLoginModule(router: self)
        pushViewController(loginViewController)
    }
    
    func showOnboarding() {
        let onboardingViewController = AppFactory.makeOnboardingModule(router: self)
        onboardingViewController.modalPresentationStyle = .fullScreen
        presentModalViewController(onboardingViewController)
    }
    
    func showSearch(context: SearchContext) {
        let searchViewController = AppFactory.makeSearchModule(router: self, context: context)
        pushViewController(searchViewController)
    }
    
    func showProductDetail(_ product: Product) {
        let productDetailViewController = AppFactory.makeProductDetailModule(router: self, product: product)
        pushViewController(productDetailViewController)
  }
    func showLocationMap() {
        let locationMapViewController = AppFactory.makeLocationMapModule(router: self)
        pushViewController(locationMapViewController)
    }
    
    func showMainTabBar() {
        let tabBarController = AppFactory.makeTabBarModule(router: self)
        navigation.setViewControllers([tabBarController], animated: true)
        navigation.presentedViewController?.dismiss(animated: false)
    }
    
    func showPaymentView() {
        let paymentViewController = AppFactory.makePaymentModule(router: self)
        paymentViewController.modalPresentationStyle = .fullScreen
        presentModalViewController(paymentViewController)
    }
    
    func showCategoriesTabBarItem() {
        guard let tabBarController = navigation.viewControllers.first as? UITabBarController else { return }
        tabBarController.selectedIndex = 2
    }
    
    func showCartTabBarItem() {
        guard let tabBarController = navigation.viewControllers.first as? UITabBarController else { return }
        tabBarController.selectedIndex = 3
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
