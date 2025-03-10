//
//  WishlistFactory.swift
//  Shoppe
//
//  Created by Николай Игнатов on 10.03.2025.
//


import UIKit

enum WishlistFactory {
    static func makeModule() -> UIViewController {
        let presenter = WishlistPresenter()
        let viewController = WishlistViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
