//
//  ExampleFactory.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//


import UIKit

enum HomeFactory {
    static func makeModule() -> UIViewController {
        let presenter = HomePresenter()
        let viewController = HomeViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
