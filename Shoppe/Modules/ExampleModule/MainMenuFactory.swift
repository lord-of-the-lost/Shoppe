//
//  ExampleFactory.swift
//  Shoppe
//
//  Created by Николай Игнатов on 03.03.2025.
//

import UIKit

enum ExampleFactory {
    static func makeModule() -> UIViewController {
        let presenter = ExamplePresenter()
        let viewController = ExampleViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
