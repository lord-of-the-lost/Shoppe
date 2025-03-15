//
//  BasketService.swift
//  Shoppe
//
//  Created by Надежда Капацина on 07.03.2025.
//

import Foundation

protocol BasketServiceProtocol {
    var items: [CartItem] { get }
    var totalItemsCount: Int { get }
    func addItem(_ item: CartItem)
    func removeItem(withId id: String)
    func updateQuantity(for itemId: String, newQuantity: Int)
}

final class BasketService: BasketServiceProtocol {

    static let shared = BasketService()
    private(set) var items: [CartItem] = []
    private init() {}
    

    var totalItemsCount: Int { 
            items.reduce(0) { $0 + $1.quantity }
        }
    
    func addItem(_ item: CartItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity += 1
        } else {
            items.append(item)
        }
        postUpdate()
    }
    
    func removeItem(withId id: String) {
        items.removeAll { $0.id == id }
        postUpdate()
    }
    
    func updateQuantity(for itemId: String, newQuantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == itemId }) else { return }
        items[index].quantity = newQuantity
        postUpdate()
    }
    
    private func postUpdate() {
        NotificationCenter.default.post(name: .basketDidUpdate, object: nil)
    }
}
