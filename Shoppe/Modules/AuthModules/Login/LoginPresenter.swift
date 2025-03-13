//
//  LoginPresenter.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

protocol LoginPresenterProtocol: AnyObject {
    func setupView(_ view: LoginViewProtocol)
    func nextButtonTapped()
    func cancelButtonTapped()
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
}

// MARK: - Presenter
final class LoginPresenter: LoginPresenterProtocol {
    private weak var view: LoginViewProtocol?
    private let router: AppRouterProtocol
    private var isEmailEntered = false
    private var emailUser: String = ""
    private var isKeyboardVisible = false
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: LoginViewProtocol) {
        self.view = view
    }
    
    func nextButtonTapped() {
        guard validateEmail() else { return }
        
        if isEmailEntered {
            handlePasswordEntry()
            guard validatePassword() else { return }
        } else {
            handleEmailEntry()
        }
    }
    
    func cancelButtonTapped() {
        if isEmailEntered {
            view?.updateNextButtonTitle("Next")
            view?.updateCancelButtonTitle("Cancel")
            view?.switchToPasswordField(is: false)
            isEmailEntered = false
        } else {
            router.dismiss(animated: true)
        }
    }
    
    func keyboardWillShow(height: CGFloat) {
        if !isKeyboardVisible {
            isKeyboardVisible = true
            view?.keyboardWillShow(height: height)
        }
    }
    
    func keyboardWillHide() {
        if isKeyboardVisible {
            isKeyboardVisible = false
            view?.keyboardWillHide()
        }
    }
}

private extension LoginPresenter {
    func checkIfUserExists(email: String, password: String) -> Bool {
        guard let savedUser: User = UserDefaultsService.shared.getCustomObject(forKey: .userModel) else {
            return false
        }
        return savedUser.email == email && savedUser.password == password
    }
    
    func handlePasswordEntry() {
        guard let password = view?.getPassword() else { return }
        if checkIfUserExists(email: emailUser, password: password) {
            loginUser()
        } else {
            if validatePassword() {
                view?.hideKeyboard()
                view?.showAlert(title: "Invalid username or password", message: nil)
            }
        }
    }
    
    func handleEmailEntry() {
        guard let email = view?.getEmail() else { return }
        
        emailUser = email
        isEmailEntered = true
        view?.updateNextButtonTitle("Done")
        view?.updateCancelButtonTitle("Back")
        view?.switchToPasswordField(is: true)
    }
    
    func validateEmail() -> Bool {
        guard let email = view?.getEmail(), !email.isEmpty else {
            view?.hideKeyboard()
            view?.showAlert(title: "Please enter your email address", message: nil)
            return false
        }
        return true
    }
    
    func validatePassword() -> Bool {
        guard let password = view?.getPassword(), !password.isEmpty else {
            view?.hideKeyboard()
            view?.showAlert(title: "Please enter your password", message: nil)
            return false
        }
        return true
    }
    
    func loginUser() {
        guard var user: User = UserDefaultsService.shared.getCustomObject(forKey: .userModel) else { return }
        user.isAuthorized = true
        UserDefaultsService.shared.saveCustomObject(user, forKey: .userModel)
    }
    
    func showOnboardingIfNeeded() {
        guard let user: User = UserDefaultsService.shared.getCustomObject(forKey: .userModel) else { return }
        switch user.isOnboardingComplete {
        case true: goToMainScreen()
        case false: goToOnboarding()
        }
    }
    
    func goToMainScreen() {
        router.showMainTabBar()
    }
    
    func goToOnboarding() {
        router.showOnboarding()
    }
}
