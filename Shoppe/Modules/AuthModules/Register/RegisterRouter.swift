//
//  RegisterRouter.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

protocol RegisterRouterProtocol {
    func openMainScreen()
    func dismissOnStart()
}

class RegisterRouter: RegisterRouterProtocol {
    weak var viewController: UIViewController?
    
    func openMainScreen() {
        print(#function)
    }
    
    func dismissOnStart() {
        print(#function)
        viewController?.dismiss(animated: true, completion: nil)
    }
}
