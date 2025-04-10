//
//  AppFactory.swift
//  Shoppe
//
//  Created by Николай Игнатов on 13.03.2025.
//

import UIKit

final class AppFactory {
    private static let networkService: NetworkServiceProtocol = NetworkService()
    private static let locationService: LocationService = LocationService()
    
    static func makeStartModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = StartPresenter(router: router)
        let viewController = StartViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
    
    static func makeLoginModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = LoginPresenter(router: router)
        let viewController = LoginViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
    
    static func makeRegistrationModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = RegisterPresenter(router: router)
        let viewController = RegisterViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
    
    static func makeCartModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = CartPresenter(router: router)
        let viewController = CartViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
    
    static func makeHomeModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = HomePresenter(router: router, networkService: networkService)
        let viewController = HomeViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
    
    static func makeTabBarModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = MainTabBarPresenter(
            router: router,
            networkService: networkService,
            basketService: BasketService.shared
        )
        let viewController = MainTabBarController(presenter: presenter)
        return viewController
    }
    
    static func makeOnboardingModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = OnboardingPresenter(router: router)
        let viewController = OnboardingViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
    
    static func makePaymentModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = PaymentPresenter(router: router)
        let viewController = PaymentViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
    
    static func makeProductDetailModule(router: AppRouterProtocol, product: Product) -> UIViewController {
        let presenter = ProductDetailPresenter(router: router, product: product)
        let viewController = ProductDetailViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
    
    static func makeSearchModule(router: AppRouterProtocol, context: SearchContext) -> UIViewController {
        let presenter = SearchPresenter(
            searchContext: context,
            router: router,
            userDefaultsService: UserDefaultsService.shared
        )
        let viewController = SearchViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
    
    static func makeSettingsModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = SettingsPresenter(router: router)
        let viewController = SettingsViewController(presenter: presenter)
        presenter.setupView(viewController, viewController: viewController)
        return viewController
    }
    
    static func makeWishlistModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = WishlistPresenter(router: router)
        let viewController = WishlistViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
    
    static func makeLocationMapModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = LocationPresenter(router: router)
        let viewController = LocationMapViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
    
    static func makeCategoriesModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = CategoriesPresenter(router: router, networkService: networkService)
        let viewController = CategoriesViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
