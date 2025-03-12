//
//  ItemViewModel.swift
//  Shoppe
//
//  Created by Daniil Murzin on 11.03.2025.
//

import UIKit

struct ItemCellViewModel: Hashable {
    let id: Int
    let image: UIImage
    let price: Double
    let description: String
    let quantity: String
}

struct ItemsMock {
    static let all: [ItemCellViewModel] = [
        ItemCellViewModel(id: 1, image: UIImage.items1, price: 19.99, description: "Red T-Shirt, 100% Cotton", quantity: "2"),
        ItemCellViewModel(id: 2, image: UIImage.itemCell1, price: 49.99, description: "Leather Wallet, Handmade", quantity: "1"),
        ItemCellViewModel(id: 3, image: UIImage.items1, price: 29.99, description: "Wireless Headphones, Noise Cancelling", quantity: "3"),
        ItemCellViewModel(id: 4, image: UIImage.items1, price: 99.99, description: "Smartwatch, Fitness Tracker", quantity: "1")
    ]
}
