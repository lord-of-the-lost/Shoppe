//
//  MainTabBarPresenter.swift
//  Shoppe
//
//  Created by Надежда Капацина on 07.03.2025.
//

import UIKit

// MARK: - Protocol
protocol MainTabBarPresenterProtocol: AnyObject {
    func setupView(_ view: MainTabBarViewProtocol)
    func viewDidLoad()
}

// MARK: - Presenter
final class MainTabBarPresenter {
    private weak var view: MainTabBarViewProtocol?
    private let basketService: BasketServiceProtocol
    private let router: AppRouterProtocol
    
    // MARK: Lifecycle
    init(router: AppRouterProtocol, basketService: BasketServiceProtocol) {
        self.basketService = basketService
        self.router = router
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - MainTabBarPresenterProtocol
extension MainTabBarPresenter: MainTabBarPresenterProtocol {
    func setupView(_ view: MainTabBarViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.updateBasketBadge(count: basketService.itemsCount)
        view?.setupTabItems(getTabItems())
    }
}

// MARK: - Private Methods
private extension MainTabBarPresenter {
    func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBasketUpdate),
            name: .basketDidUpdate,
            object: nil
        )
    }
    
    func getTabItems() -> [TabItemModel] {
        [
            TabItemModel(
                viewController: HomeFactory.makeModule(),
                iconName: "Home",
                selectedIconName: "HomeSelected"
            ),
            TabItemModel(
                viewController: WishlistFactory.makeModule(),
                iconName: "Heart",
                selectedIconName: "HeartSelected"
            ),
            TabItemModel(
                viewController: UIViewController(),
                iconName: "Categories",
                selectedIconName: "CategoriesSelected"
            ),
            TabItemModel(
                viewController: UIViewController(),
                iconName: "Bag",
                selectedIconName: "BagSelected"
            ),
            TabItemModel(
                viewController: SettingsFactory.makeModule(router: router),
                iconName: "Person",
                selectedIconName: "PersonSelected"
            )
        ]
    }
    
    @objc func handleBasketUpdate() {
        view?.updateBasketBadge(count: basketService.itemsCount)
    }
}
