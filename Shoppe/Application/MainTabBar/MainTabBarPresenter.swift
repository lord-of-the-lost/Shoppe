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

final class MainTabBarPresenter: MainTabBarPresenterProtocol {
    weak var view: MainTabBarViewProtocol?
    private let basketService: BasketServiceProtocol
    
    init(basketService: BasketServiceProtocol) {
        self.basketService = basketService
        setupObservers()
    }
    
    func viewDidLoad() {
        view?.updateBasketBadge(count: basketService.itemsCount)
    }
}

// MARK: - Private Methods

private extension MainTabBarPresenter {
    func setupObservers() {
        basketService.observeBasketUpdates(
            observer: self,
            selector: #selector(handleBasketUpdate)
        )
    }
    
    @objc private func handleBasketUpdate() {
        view?.updateBasketBadge(count: basketService.itemsCount)
    }
}

    

