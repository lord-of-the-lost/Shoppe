//
//  SettingsRouterProtocol.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/12/25.
//


import UIKit

protocol SettingsRouterProtocol {
    func openLoginScreen()
    func openRegistrationScreen()
}

final class SettingsRouter: SettingsRouterProtocol {
    weak var viewController: UIViewController?
    
    func setupView(_ view: SettingsViewProtocol) {
        self.viewController = view as? UIViewController
    }
    
    func openLoginScreen() {
        let vc = LoginFactory.makeModule()
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func openRegistrationScreen() {
        let vc = RegisterFactory.makeModule()
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
}
