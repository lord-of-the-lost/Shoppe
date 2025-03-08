//
//  RegisterRouter.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

protocol RegisterRouterProtocol {
    func openLoginScreen()
    func dismissOnStart()
}

class RegisterRouter: RegisterRouterProtocol {
    weak var viewController: UIViewController?
    
    func openLoginScreen() {
        let vc = LoginFactory.makeModule()
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func dismissOnStart() {
        print(#function)
        viewController?.dismiss(animated: true, completion: nil)
    }
}
