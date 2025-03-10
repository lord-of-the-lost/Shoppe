//
//  StartRouter.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

protocol StartRouterProtocol {
    func openLoginScreen()
    func openRegistrationScreen()
}

final class StartRouter: StartRouterProtocol {
    weak var viewController: UIViewController?
    
    func setupView(_ view: StartViewProtocol) {
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
