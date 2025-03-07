//
//  MainTabBarPresenter.swift
//  Shoppe
//
//  Created by Надежда Капацина on 07.03.2025.
//

import UIKit

final class MainTabBarPresenter {
    weak var view: MainTabBarViewProtocol?
    private let basketService: BasketServiceProtocol
    
    init(view: MainTabBarViewProtocol, basketService: BasketServiceProtocol = BasketService.shared) {
        self.view = view
        self.basketService = basketService
        setupObservers()
    }
    
    private func setupObservers() {
        basketService.observeBasketUpdates(
            observer: self,
            selector: #selector(handleBasketUpdate)
        )
    }
    
    @objc private func handleBasketUpdate() {
        view?.updateBasketBadge(count: basketService.itemsCount)
    }
    
    func viewDidLoad() {
        view?.updateBasketBadge(count: basketService.itemsCount)
    }
}
