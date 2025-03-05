//
//  Categories.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//

import UIKit

struct CategoryCellViewModel: Hashable {
    let id: Int
    let name: String
    let images: [UIImage]
    var count: Int
}

struct Categories {
    static var all: [CategoryCellViewModel] = [
        CategoryCellViewModel(id: 0, name: "Electronics", images: [
            UIImage(systemName: "desktopcomputer") ?? UIImage(),
            UIImage(systemName: "tv") ?? UIImage(),
            UIImage(systemName: "headphones") ?? UIImage(),
            UIImage(systemName: "camera") ?? UIImage()
        ], count: 0),
        
        CategoryCellViewModel(id: 1, name: "Clothing", images: [
            UIImage(systemName: "tshirt") ?? UIImage(),
            UIImage(systemName: "shoe.fill") ?? UIImage(),
            UIImage(systemName: "hat") ?? UIImage(),
            UIImage(systemName: "handbag") ?? UIImage()
        ], count: 0),
        
        CategoryCellViewModel(id: 2, name: "Home & Kitchen", images: [
            UIImage(systemName: "house") ?? UIImage(),
            UIImage(systemName: "lamp.ceiling.fill") ?? UIImage(),
            UIImage(systemName: "cup.and.saucer.fill") ?? UIImage(),
            UIImage(systemName: "bed.double.fill") ?? UIImage()
        ], count: 0),
        
        CategoryCellViewModel(id: 3, name: "Sports", images: [
            UIImage(systemName: "sportscourt.fill") ?? UIImage(),
            UIImage(systemName: "bicycle") ?? UIImage(),
            UIImage(systemName: "tennisball.fill") ?? UIImage(),
            UIImage(systemName: "figure.run") ?? UIImage()
        ], count: 0)
    ]
}
