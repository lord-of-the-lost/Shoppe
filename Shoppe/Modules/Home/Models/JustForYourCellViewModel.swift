//
//  JustForYourCellViewModel.swift
//  Shoppe
//
//  Created by Daniil Murzin on 05.03.2025.
//

import UIKit

struct JustForYourCellViewModel: Hashable {
    let id: Int
    let image: UIImage
    let price: String
    let description: String
    let isFavorite: Bool
}

struct JustForYouMock {
    static let all: [JustForYourCellViewModel] = [
        JustForYourCellViewModel(
            id: 0,
            image: UIImage(named: "product") ?? UIImage(),
            price: "$17.00",
            description: "Lorem ipsum dolor sit amet consectetur",
            isFavorite: false
        ),
        JustForYourCellViewModel(
            id: 1,
            image: UIImage(named: "product") ?? UIImage(),
            price: "$45.99",
            description: "Elegant dress for every occasion",
            isFavorite: true
        ),
        JustForYourCellViewModel(
            id: 2,
            image: UIImage(named: "product") ?? UIImage(),
            price: "$89.50",
            description: "Stylish jacket with modern fit",
            isFavorite: false
        ),
        JustForYourCellViewModel(
            id: 3,
            image: UIImage(named: "product") ?? UIImage(),
            price: "$22.99",
            description: "Casual sneakers for daily wear",
            isFavorite: true
        ),
        JustForYourCellViewModel(
            id: 4,
            image: UIImage.plscomeagain,
            price: "$12.49",
            description: "Comfortable cotton t-shirt",
            isFavorite: false
        )
    ]
}
