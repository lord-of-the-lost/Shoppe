//
//  WishlistPresenter.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 06.03.2025.
//

import UIKit

protocol WishlistPresenterProtocol {
    func getProductsCount() -> Int
    func getProductViewModel(at index: Int) -> ProductCellViewModel?
    func didTapProduct(at index: Int)
    func addToCartProduct(at index: Int)
    func toggleProductLike(at index: Int)
    func showSearch()
}

final class WishlistPresenter {
    // MARK: - Properties
    private weak var view: WishlistViewProtocol?
    private let router: AppRouterProtocol
    private let basketService: BasketServiceProtocol
    private let wishlistService: WishlistServiceProtocol
    private let userDefaultsService: UserDefaultsService = UserDefaultsService.shared
    
    private var currentCurrency: Currency {
        guard let user: User = userDefaultsService.getCustomObject(forKey: .userModel) else {
            return .dollar
        }
        return user.currentCurrency
    }
    
    private var products: [Product] {
        wishlistService.items
    }
    
    // MARK: - Initialization
    init(
        router: AppRouterProtocol,
        basketService: BasketServiceProtocol = BasketService.shared,
        wishlistService: WishlistServiceProtocol = WishlistService.shared
    ) {
        self.router = router
        self.basketService = basketService
        self.wishlistService = wishlistService
        setupNotifications()
    }
    
    func setupView(_ view: WishlistViewProtocol) {
        self.view = view
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - WishlistPresenterProtocol
extension WishlistPresenter: WishlistPresenterProtocol {
    func getProductsCount() -> Int {
        products.count
    }
    
    func getProductViewModel(at index: Int) -> ProductCellViewModel? {
        guard let product = products[safe: index] else { return nil }
        var updatedProduct = product
        updatedProduct.isInCart = basketService.contains(product)
        updatedProduct.isInWishlist = wishlistService.contains(product)
        
        let viewModel = ProductCellViewModel(
            id: updatedProduct.id,
            image: updatedProduct.image,
            title: updatedProduct.title,
            price: currentCurrency.formatPrice(updatedProduct.price),
            isOnCart: updatedProduct.isInCart,
            isOnWishlist: updatedProduct.isInWishlist
        )
        return viewModel
    }
    
    func didTapProduct(at index: Int) {
        guard let product = products[safe: index] else { return }
        router.showProductDetail(product)
    }
    
    func addToCartProduct(at index: Int) {
        guard let product = products[safe: index] else { return }
        
        if basketService.contains(product) {
            basketService.removeItem(product)
        } else {
            basketService.addItem(product)
        }
        
        view?.reloadData()
    }
    
    func showSearch() {
        router.showSearch(context: .wishlist)
    }
    
    func toggleProductLike(at index: Int) {
        guard let product = products[safe: index] else { return }
        wishlistService.removeItem(product)
        view?.reloadData()
    }
}

// MARK: - Private Methods
private extension WishlistPresenter {
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleWishlistUpdate),
            name: .wishlistDidUpdate,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBasketUpdate),
            name: .basketDidUpdate,
            object: nil
        )
    }
    
    @objc func handleWishlistUpdate() {
        view?.reloadData()
    }
    
    @objc func handleBasketUpdate() {
        view?.reloadData()
    }
}
