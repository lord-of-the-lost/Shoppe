//
//  AllCategoriesScreenBuilder.swift
//  Shoppe
//
//  Created by Вячеслав on 06.03.2025.
//

import UIKit

protocol AllCategoriesScreenBuilderProtocol {
    static func buildAllCategoriesScreen() -> UIViewController
}

final class AllCategoriesScreenBuilder: AllCategoriesScreenBuilderProtocol {
    static func buildAllCategoriesScreen() -> UIViewController {
        let view = AllCategoriesScreenViewController()
        let presenter = AllCategoriesScreenPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    
}
