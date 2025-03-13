//
//  SearchFactory.swift
//  Shoppe
//
//  Created by Николай Игнатов on 11.03.2025.
//

import UIKit

enum SearchFactory {
    static func makeModule() -> UIViewController {
        let presenter = SearchPresenter()
        let viewController = SearchViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
