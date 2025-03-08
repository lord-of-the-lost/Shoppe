//
//  BasketService.swift
//  Shoppe
//
//  Created by Надежда Капацина on 07.03.2025.
//

import Foundation

protocol BasketServiceProtocol {
    var itemsCount: Int { get }
    func addItem()
    func removeItem()
}

final class BasketService: BasketServiceProtocol {
    static let shared = BasketService()
    
    private init() {}
    
// TODO: Заменить на тип данных продукта
    private var items: [String] = []
    
    var itemsCount: Int { items.count }
    
    func addItem() {
        items.append("Item")
        NotificationCenter.default.post(name: .basketDidUpdate, object: nil)
    }
    
    func removeItem() {
        if !items.isEmpty { items.removeLast() }
        NotificationCenter.default.post(name: .basketDidUpdate, object: nil)
    }
}
