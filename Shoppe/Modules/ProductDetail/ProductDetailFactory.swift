//
//  ProductDetailFactory.swift
//  Shoppe
//
//  Created by Николай Игнатов on 08.03.2025.
//

import UIKit

enum ProductDetailFactory {
    static func makeModule() -> UIViewController {
        let presenter = ProductDetailPresenter()
        let viewController = ProductDetailViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
