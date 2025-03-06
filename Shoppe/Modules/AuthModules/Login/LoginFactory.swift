//
//  LoginFactory.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

enum LoginFactory {
    static func makeModule() -> UIViewController {
        let router = LoginRouter()
        let presenter = LoginPresenter(router: router)
        let viewController = LoginViewController(presenter: presenter)
        router.viewController = viewController
        presenter.setupView(viewController)
        return viewController
    }
}
