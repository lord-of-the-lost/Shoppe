//
//  WishlistPresenter.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 06.03.2025.
//

import UIKit

protocol WishlistPresenterProtocol {
    func getProductsCount() -> Int
    func getProduct(at index: Int) -> Product?
    func didTapProduct(at index: Int)
    func addToCartProduct(at index: Int)
    func toggleProductLike(at index: Int)
}

final class WishlistPresenter {
    private weak var view: WishlistViewProtocol?
    var product: User? = UserDefaultsService.shared.getCustomObject(forKey: .userModel)
    var products: [Product] = []
    
    func setupView(_ view: WishlistViewProtocol) {
        self.view = view
        loadProducts()
    }
    
    func loadProducts() {
        products = [
            Product(id: 1, title: "Blue Shirt", price: 200, description: "A blue shirt", category: .jewelery, imageData: Data(), isInWishlist: false),
            Product(id: 2, title: "Red Dress", price: 250, description: "A red dress", category: .womensClothing, imageData: Data(), isInWishlist: false),
            Product(id: 3, title: "Gold Necklace", price: 150, description: "A gold necklace", category: .jewelery, imageData: Data(), isInWishlist: false),
            Product(id: 4, title: "Men's Watch", price: 300, description: "A men's watch", category: .mensClothing, imageData: Data(), isInWishlist: false),
        ]
        print(products.count)
        view?.reloadData()
    }
}

// MARK: - WishlistPresenterProtocol
extension WishlistPresenter: WishlistPresenterProtocol {
    func getProductsCount() -> Int {
        products.count
    }
    
    func getProduct(at index: Int) -> Product? {
        products[safe: index]
    }
    
    func didTapProduct(at index: Int) {
        print(index)
    }
    
    func addToCartProduct(at index: Int) {
        print(index)
    }
    
    func toggleProductLike(at index: Int) {
        guard var user: User? =  UserDefaultsService.shared.getCustomObject(forKey: .userModel) else { return }
        if ((user?.wishList.indices.contains(index)) != nil) {
            user?.wishList.remove(at: index)
            print("Product removed from wishlist at index: \(index)")
        }
        UserDefaultsService.shared.saveCustomObject(user, forKey: .userModel)
        view?.reloadData()
        print(index)
    }
}
