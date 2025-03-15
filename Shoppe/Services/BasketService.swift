//
//  BasketService.swift
//  Shoppe
//
//  Created by Надежда Капацина on 07.03.2025.
//

import Foundation

// MARK: - Basket Service
protocol BasketServiceProtocol {
    var items: [Product] { get }
    var totalItemsCount: Int { get }
    func addItem(_ product: Product)
    func removeItem(_ product: Product)
    func contains(_ product: Product) -> Bool
    func updateQuantity(for productId: Int, newQuantity: Int)
    func clearBasket()
}

final class BasketService: BasketServiceProtocol {
    static let shared = BasketService()
    private let userDefaultsService = UserDefaultsService.shared
    
    private init() {}
    
    var items: [Product] {
        guard let user: User = userDefaultsService.getCustomObject(forKey: .userModel) else { return [] }
        return user.cart
    }
    
    var totalItemsCount: Int {
        items.reduce(0) { $0 + $1.count }
    }
    
    func addItem(_ product: Product) {
        guard var user: User = userDefaultsService.getCustomObject(forKey: .userModel) else { return }
        
        if let index = user.cart.firstIndex(where: { $0.id == product.id }) {
            user.cart[index].count += 1
        } else {
            var updatedProduct = product
            updatedProduct.isInCart = true
            updatedProduct.count = 1
            user.cart.append(updatedProduct)
        }
        
        userDefaultsService.saveCustomObject(user, forKey: .userModel)
        postUpdate()
    }
    
    func removeItem(_ product: Product) {
        guard var user: User = userDefaultsService.getCustomObject(forKey: .userModel) else { return }
        
        user.cart.removeAll { $0.id == product.id }
        userDefaultsService.saveCustomObject(user, forKey: .userModel)
        postUpdate()
    }
    
    func contains(_ product: Product) -> Bool {
        items.contains { $0.id == product.id }
    }
    
    func updateQuantity(for productId: Int, newQuantity: Int) {
        guard
            var user: User = userDefaultsService.getCustomObject(forKey: .userModel),
            let index = user.cart.firstIndex(where: { $0.id == productId })
        else { return }
        
        if newQuantity <= 0 {
            user.cart.remove(at: index)
        } else {
            user.cart[index].count = newQuantity
        }
        
        userDefaultsService.saveCustomObject(user, forKey: .userModel)
        postUpdate()
    }
    
    func clearBasket() {
        guard var user: User = userDefaultsService.getCustomObject(forKey: .userModel) else { return }
        
        user.cart.removeAll()
        userDefaultsService.saveCustomObject(user, forKey: .userModel)
        postUpdate()
    }
    
    private func postUpdate() {
        NotificationCenter.default.post(name: .basketDidUpdate, object: nil)
    }
}
