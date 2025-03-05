//
//  RegisterFactory.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

enum RegisterFactory {
    static func makeModule() -> UIViewController {
        let router = RegisterRouter()
        let presenter = RegisterPresenter(router: router)
        let viewController = RegisterViewController(presenter: presenter)
        router.viewController = viewController
        presenter.setupView(viewController)
        return viewController
    }
}
