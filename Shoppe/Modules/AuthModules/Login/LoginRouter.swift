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

class LoginRouter: LoginRouterProtocol {
    weak var viewController: UIViewController?
    
    func openMainScreen() {
        print(#function)
    }
    
    func dismissOnStart() {
        print(#function)
        viewController?.dismiss(animated: true, completion: nil)
    }
}
