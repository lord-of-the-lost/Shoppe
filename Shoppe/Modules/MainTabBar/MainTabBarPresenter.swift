//
//  MainTabBarPresenter.swift
//  Shoppe
//
//  Created by Надежда Капацина on 07.03.2025.
//

import UIKit

// MARK: - Protocol
protocol MainTabBarPresenterProtocol: AnyObject {
    func viewDidLoad()
}

// MARK: - Presenter
final class MainTabBarPresenter {
    private weak var view: MainTabBarViewProtocol?
    private let basketService: BasketServiceProtocol
    
    // MARK: Lifecycle
    init(basketService: BasketServiceProtocol) {
        self.basketService = basketService
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Internal Methods
    func setupView(_ view: MainTabBarViewProtocol) {
        self.view = view
    }
}

// MARK: - MainTabBarPresenterProtocol
extension MainTabBarPresenter: MainTabBarPresenterProtocol {
    func viewDidLoad() {
        view?.updateBasketBadge(count: basketService.itemsCount)
    }
}

// MARK: - Private Methods
private extension MainTabBarPresenter {
    func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBasketUpdate),
            name: .basketDidUpdate,
            object: nil
        )
    }
    
    @objc func handleBasketUpdate() {
        view?.updateBasketBadge(count: basketService.itemsCount)
    }
}
