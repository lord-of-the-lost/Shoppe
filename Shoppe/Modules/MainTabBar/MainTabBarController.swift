//
//  MainTabBarController.swift
//  Shoppe
//
//  Created by Надежда Капацина on 04.03.2025.
//

import UIKit

// MARK: - Protocol
protocol MainTabBarViewProtocol: AnyObject {
    func setupTabItems(_ items: [TabItemModel])
    func updateBasketBadge(count: Int)
}

// MARK: - MainTabBarController
final class MainTabBarController: UITabBarController {
    private let presenter: MainTabBarPresenterProtocol
    private let basketTabIndex = 3

    // MARK: - Setup

    private var tabItems: [TabItemModel] = []
    
    // MARK: Lifecycle
    init(presenter: MainTabBarPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupView(self)
        presenter.viewDidLoad()
        configureTabBarAppearance()
    }
}

// MARK: - MainTabBarViewProtocol
extension MainTabBarController: MainTabBarViewProtocol {
    func setupTabItems(_ items: [TabItemModel]) {
        tabItems = items
        setupViewControllers()
    }
    
    func updateBasketBadge(count: Int) {
        guard
            let tabItems = tabBar.items,
            let basketTabItem = tabItems[safe: basketTabIndex]
        else { return }
        basketTabItem.badgeValue = count > 0 ? "\(count)" : nil
    }
}

// MARK: - Private Methods
private extension MainTabBarController {
    func setupViewControllers() {
        viewControllers = tabItems.map { item in
            let controller = item.viewController
            controller.tabBarItem = createTabBarItem(
                iconName: item.iconName,
                selectedIconName: item.selectedIconName
            )
            return controller
        }
    }
    
    func createTabBarItem(iconName: String, selectedIconName: String) -> UITabBarItem {
        UITabBarItem(
            title: nil,
            image: UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: selectedIconName)?.withRenderingMode(.alwaysOriginal)
        )
    }
    
    func configureTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBar.standardAppearance = tabBarAppearance
    }
}
