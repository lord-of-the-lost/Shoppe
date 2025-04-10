//
//  RegisterPresenter.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import Foundation

protocol RegisterPresenterProtocol: AnyObject {
    func doneButtonTapped(email: String?, password: String?)
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
    func setupView(_ view: RegisterViewProtocol)
    func cancelButtonTapped()
}

// MARK: - Presenter
final class RegisterPresenter: RegisterPresenterProtocol {
    private weak var view: RegisterViewProtocol?
    private let router: AppRouterProtocol
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: RegisterViewProtocol) {
        self.view = view
    }
    
    func doneButtonTapped(email: String?, password: String?) {
        guard
            let email = email,
            let password = password,
            validateEmail(),
            validatePassword()
        else {
            return
        }
        saveUser(email: email, password: password)
        showLoginScreen()
    }
    
    func cancelButtonTapped() { router.popViewController(animated: true) }
    
    func keyboardWillShow(height: CGFloat) {
        view?.keyboardWillShow(height: height)
    }
    
    func keyboardWillHide() {
        view?.keyboardWillHide()
    }
}

// MARK: - Private Methods
private extension RegisterPresenter {
    func saveUser(email: String, password: String) {
        let user = User(email: email, password: password)
        UserDefaultsService.shared.saveCustomObject(user, forKey: .userModel)
    }
    
    private func validateEmail() -> Bool {
        guard let email = view?.getEmail(), !email.isEmpty else {
            view?.showAlert(title: "Please enter your email address", message: nil)
            return false
        }
        return true
    }
    
    private func validatePassword() -> Bool {
        guard let password = view?.getPassword(), !password.isEmpty else {
            view?.showAlert(title: "Please enter your password", message: nil)
            return false
        }
        return true
    }
    
    func showLoginScreen() {
        router.showLoginScreen()
    }
}
