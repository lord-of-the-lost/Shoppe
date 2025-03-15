//
//  WishlistServiceProtocol.swift
//  Shoppe
//
//  Created by Николай Игнатов on 15.03.2025.
//

import Foundation

// MARK: - Wishlist Service
protocol WishlistServiceProtocol {
    var items: [Product] { get }
    var itemsCount: Int { get }
    func addItem(_ product: Product)
    func removeItem(_ product: Product)
    func contains(_ product: Product) -> Bool
    func clearWishlist()
}

final class WishlistService: WishlistServiceProtocol {
    static let shared = WishlistService()
    private let userDefaultsService = UserDefaultsService.shared
    
    private init() {}
    
    var items: [Product] {
        guard let user: User = userDefaultsService.getCustomObject(forKey: .userModel) else { return [] }
        return user.wishList
    }
    
    var itemsCount: Int { items.count }
    
    func addItem(_ product: Product) {
        guard
            var user: User = userDefaultsService.getCustomObject(forKey: .userModel),
            !contains(product)
        else { return }
        
        var updatedProduct = product
        updatedProduct.isInWishlist = true
        user.wishList.append(updatedProduct)
        userDefaultsService.saveCustomObject(user, forKey: .userModel)
        NotificationCenter.default.post(name: .wishlistDidUpdate, object: nil)
    }
    
    func removeItem(_ product: Product) {
        guard var user: User = userDefaultsService.getCustomObject(forKey: .userModel) else { return }
        
        user.wishList.removeAll { $0.id == product.id }
        userDefaultsService.saveCustomObject(user, forKey: .userModel)
        NotificationCenter.default.post(name: .wishlistDidUpdate, object: nil)
    }
    
    func contains(_ product: Product) -> Bool {
        items.contains { $0.id == product.id }
    }
    
    func clearWishlist() {
        guard var user: User = userDefaultsService.getCustomObject(forKey: .userModel) else { return }
        
        user.wishList.removeAll()
        userDefaultsService.saveCustomObject(user, forKey: .userModel)
        NotificationCenter.default.post(name: .wishlistDidUpdate, object: nil)
    }
}
