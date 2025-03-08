//
//  LoginPresenter.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

protocol LoginPresenterProtocol: AnyObject {
    func setupView(_ view: LoginViewProtocol)
    func nextButtonTapped(button: UIButton)
    func cancelButtonTapped()
}

// MARK: - Presenter
final class LoginPresenter: LoginPresenterProtocol {
    private weak var view: LoginViewProtocol?
    private let router: LoginRouterProtocol
    private var isEmailEntered = false
    private var emailUser: String = ""
    
    init(router: LoginRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: LoginViewProtocol) {
        self.view = view
    }
    
    
    func nextButtonTapped(button: UIButton) {
        
        if isEmailEntered {
            guard let password = view?.getPassword() else { return }
            
            if checkIfUserExists(username: emailUser, password: password) {
                print("Авторизация успешна")
                router.openMainScreen()
            } else {
                print("Пользователь отсутствует")
            }
            return
        }
        
        guard let email = view?.getEmail() else { return }
        emailUser = email

        isEmailEntered = true
        view?.updateButtonTitle("Done")
        view?.switchToPasswordField()
    }
    
    func cancelButtonTapped() { router.dismissOnStart() }
}

private extension LoginPresenter {
    func checkIfUserExists(username: String, password: String) -> Bool {
        guard let savedUser: User = UserDefaultsService.shared.getCustomObject(forKey: .username) else {
            return false
        }
        return savedUser.username == username && savedUser.password == password
    }

}
