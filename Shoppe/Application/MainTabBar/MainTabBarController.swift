//
//  MainTabBarController.swift
//  Shoppe
//
//  Created by Надежда Капацина on 04.03.2025.
//

import UIKit

// MARK: - Protocol

protocol MainTabBarViewProtocol: AnyObject {
    func updateBasketBadge(count: Int)
}
// MARK: - MainTabBarController

final class MainTabBarController: UITabBarController {
    
    private let presenter: MainTabBarPresenterProtocol
    private let basketTabIndex = 3
     
    init(presenter: MainTabBarPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    private var tabItems: [TabItemModel] = [
        TabItemModel(
            viewController: TestBasketViewController(),
            iconName: "Home",
            selectedIconName: "HomeSelected"
        ),
        TabItemModel(
            viewController: UIViewController(),
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
            viewController: UIViewController(),
            iconName: "Person",
            selectedIconName: "PersonSelected"
        )
    ]
    
}
// MARK: - Private Methods

private extension MainTabBarController {
    
    func setupViewControllers() {
        viewControllers = tabItems.map { config in
            let navController = UINavigationController(rootViewController: config.viewController)
            navController.tabBarItem = createTabBarItem(
                iconName: config.iconName,
                selectedIconName: config.selectedIconName
            )
            return navController
        }
    }
    
    func createTabBarItem(iconName: String, selectedIconName: String) -> UITabBarItem {
        UITabBarItem(
            title: nil,
            image: UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: selectedIconName)?.withRenderingMode(.alwaysOriginal)
        )
    }
}

// MARK: - MainTabBarViewProtocol
extension MainTabBarController: MainTabBarViewProtocol {
    func updateBasketBadge(count: Int) {
        guard let tabItems = tabBar.items, basketTabIndex < tabItems.count else { return }
        let basketTabItem = tabItems[basketTabIndex]
        basketTabItem.badgeValue = count > 0 ? "\(count)" : nil
    }
}
