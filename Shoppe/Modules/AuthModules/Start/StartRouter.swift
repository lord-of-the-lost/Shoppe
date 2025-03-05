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
//        let loginVC = LoginViewController()
//        viewController?.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func openRegistrationScreen() {
        print(#function)
//        let registerVC = RegisterViewController()
//        viewController?.navigationController?.pushViewController(registerVC, animated: true)
    }
}
