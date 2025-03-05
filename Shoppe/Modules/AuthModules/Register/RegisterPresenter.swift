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

    
    func doneButtonTapped() { router.openMainScreen() }
    
    func cancelButtonTapped() { router.dismissOnStart() }

}

// MARK: - Private Methods
private extension RegisterPresenter {
    
}
