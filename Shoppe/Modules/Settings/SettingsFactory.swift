//
//  SettingsFactory.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/12/25.
//


import UIKit

enum SettingsFactory {
    static func makeModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = SettingsPresenter(router: router)
        let viewController = SettingsViewController(presenter: presenter)
        presenter.setupView(viewController, viewController: viewController)
        return viewController
    }
}
