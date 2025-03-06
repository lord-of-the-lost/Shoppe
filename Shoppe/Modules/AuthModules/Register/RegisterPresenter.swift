//
//  RegisterPresenter.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import Foundation

protocol RegisterPresenterProtocol: AnyObject {
    func setupView(_ view: RegisterViewProtocol)
    func doneButtonTapped()
    func cancelButtonTapped()
}

// MARK: - Presenter
final class RegisterPresenter: RegisterPresenterProtocol {
    private weak var view: RegisterViewProtocol?
    private let router: RegisterRouterProtocol
    
    init(router: RegisterRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: RegisterViewProtocol) {
    self.view = view
    }

    
    func doneButtonTapped() {
        guard let email = view?.getEmail() else { return }
        guard let password = view?.getPassword() else { return }
        print(email, password)
        saveUser(username: email, password: password)
        router.openLoginScreen()
    }
    
    func cancelButtonTapped() { router.dismissOnStart() }

}

// MARK: - Private Methods
private extension RegisterPresenter {
    func saveUser(username: String, password: String) {
        let user = User(username: username, password: password)
        UserDefaultsService.shared.saveCustomObject(user, forKey: .username)
    }
}
