//
//  LoginRouter.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

protocol LoginRouterProtocol {
    func openMainScreen()
    func dismissOnStart()
}

final class LoginRouter: LoginRouterProtocol {
    weak var viewController: UIViewController?
    
    func setupView(_ view: LoginViewProtocol) {
        self.viewController = view as? UIViewController
    }
    
    func openMainScreen() {
        let vc = MainTabBarFactory.makeModule()
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func dismissOnStart() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
