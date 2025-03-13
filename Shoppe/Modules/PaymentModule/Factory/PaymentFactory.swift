//
//  PaymentFactory.swift
//  Shoppe
//
//  Created by Daniil Murzin on 11.03.2025.
//


import UIKit

enum PaymentFactory {
    static func makeModule() -> UIViewController {
        let presenter = PaymentPresenter()
        let viewController = PaymentViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
