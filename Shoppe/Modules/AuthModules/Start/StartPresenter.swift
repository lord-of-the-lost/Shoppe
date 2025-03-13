//
//  StartPresenter.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import Foundation

protocol StartPresenterProtocol: AnyObject {
    func setupView(_ view: StartViewProtocol)
    func startButtonTapped()
    func alreadyButtonTapped()
}

// MARK: - Presenter
final class StartPresenter: StartPresenterProtocol {
    private weak var view: StartViewProtocol?
    private let router: AppRouterProtocol
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: StartViewProtocol) {
        self.view = view
    }
    
    func startButtonTapped() { router.showRegistrationScreen() }
    
    func alreadyButtonTapped() { router.showLoginScreen() }
}
