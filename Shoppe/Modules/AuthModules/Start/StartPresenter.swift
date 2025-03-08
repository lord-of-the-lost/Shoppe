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
    private let router: StartRouterProtocol
    
    init(router: StartRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: StartViewProtocol) {
        self.view = view
    }
    
    func startButtonTapped() { router.openRegistrationScreen() }
    
    func alreadyButtonTapped() { router.openLoginScreen() }
}
