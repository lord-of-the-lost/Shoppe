//
//  StartFactory.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

enum StartFactory {
    static func makeModule() -> UIViewController {
        let router = StartRouter()
        let presenter = StartPresenter(router: router)
        let viewController = StartViewController(presenter: presenter)
        router.setupView(viewController)
        presenter.setupView(viewController)
        return viewController
    }
}
