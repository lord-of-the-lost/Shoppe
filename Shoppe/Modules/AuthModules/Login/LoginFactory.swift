//
//  LoginFactory.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

enum LoginFactory {
    static func makeModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = LoginPresenter(router: router)
        let viewController = LoginViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
