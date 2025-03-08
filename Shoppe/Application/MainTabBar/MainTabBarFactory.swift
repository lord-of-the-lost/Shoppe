//
//  MainTabBarFactory.swift
//  Shoppe
//
//  Created by Надежда Капацина on 08.03.2025.
//

import UIKit

enum MainTabBarFactory {
    static func makeModule() -> UIViewController {
        let presenter = MainTabBarPresenter(basketService: BasketService.shared)
        let viewController = MainTabBarController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
