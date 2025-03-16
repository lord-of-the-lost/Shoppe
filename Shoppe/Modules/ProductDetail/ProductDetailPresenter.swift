//
//  ProductDetailPresenter.swift
//  Shoppe
//
//  Created by Николай Игнатов on 08.03.2025.
//

import UIKit

protocol ProductDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func toggleLike()
    func toggleCart()
    func buyNowTapped()
    func backButtonTapped()
}

final class ProductDetailPresenter {
    private weak var view: ProductDetailViewProtocol?
    private let product: Product
    private let router: AppRouterProtocol
    private let basketService: BasketServiceProtocol = BasketService.shared
    private let wishlistService: WishlistServiceProtocol = WishlistService.shared
    
    private var viewModel: ProductDetailViewModel {
        ProductDetailViewModel(
            price: String(format: "$%.2f", product.price),
            description: product.description,
            isLiked: wishlistService.contains(product),
            isInCart: basketService.contains(product),
            images: [product.image, product.image, product.image].compactMap { $0 }
        )
    }
    
    init(router: AppRouterProtocol, product: Product) {
        self.product = product
        self.router = router
    }
    
    func setupView(_ view: ProductDetailViewProtocol) {
        self.view = view
    }
}

// MARK: - ProductDetailPresenterProtocol
extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    func viewDidLoad() {
        view?.updateView(with: viewModel)
    }
    
    func toggleLike() {
        if wishlistService.contains(product) {
            wishlistService.removeItem(product)
        } else {
            wishlistService.addItem(product)
        }
        view?.updateLikeState(wishlistService.contains(product))
    }
    
    func toggleCart() {
        if basketService.contains(product) {
            basketService.removeItem(product)
        } else {
            basketService.addItem(product)
        }
        view?.updateCartState(basketService.contains(product))
    }
    
    func buyNowTapped() {
        print(#function)
    }
    
    func backButtonTapped() {
        router.popViewController(animated: true)
    }
}
