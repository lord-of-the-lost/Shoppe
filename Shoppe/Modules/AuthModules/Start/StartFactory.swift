//
//  StartFactory.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

enum StartFactory {
    static func makeModule(router: AppRouterProtocol) -> UIViewController {
        let presenter = StartPresenter(router: router)
        let viewController = StartViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
