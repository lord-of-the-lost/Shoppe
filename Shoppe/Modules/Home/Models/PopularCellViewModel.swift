//
//  PopularCellViewModel.swift
//  Shoppe
//
//  Created by Daniil Murzin on 05.03.2025.
//

import UIKit

struct PopularCellViewModel: Hashable {
    let id: Int
    let image: UIImage
    let price: Double
    let description: String
}

struct PopularMock {
    static let all: [PopularCellViewModel] = [
        PopularCellViewModel(
            id: 0,
            image: UIImage(named: "product") ?? UIImage(),
            price: 17.00,
            description: "Stylish sneakers for daily wear."
        ),
        PopularCellViewModel(
            id: 1,
            image: UIImage(named: "product") ?? UIImage(),
            price: 45.99,
            description: "Elegant dress for special occasions."
        ),
        PopularCellViewModel(
            id: 2,
            image: UIImage(named: "product") ?? UIImage(),
            price: 89.50,
            description: "Modern smartwatch with fitness tracking."
        ),
        PopularCellViewModel(
            id: 3,
            image: UIImage(named: "product") ?? UIImage(),
            price: 22.99,
            description: "Comfortable cotton t-shirt."
        ),
        PopularCellViewModel(
            id: 4,
            image: UIImage(named: "product") ?? UIImage(),
            price: 12.49,
            description: "Casual baseball cap, one size fits all."
        ),
        PopularCellViewModel(
            id: 5,
            image: UIImage(named: "product") ?? UIImage(),
            price: 129.99,
            description: "High-performance wireless headphones."
        )
    ]
}

