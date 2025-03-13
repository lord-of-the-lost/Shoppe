//
//  RegistrationFactory.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

enum RegistrationFactory {
    static func makeModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = RegisterPresenter(router: router)
        let viewController = RegisterViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
