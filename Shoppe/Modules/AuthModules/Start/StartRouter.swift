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

class StartRouter: StartRouterProtocol {
    weak var viewController: UIViewController?
    
    func openLoginScreen() {
        print(#function)
        let vc = LoginFactory.makeModule()
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func openRegistrationScreen() {
        print(#function)
        let vc = RegisterFactory.makeModule()
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
}
