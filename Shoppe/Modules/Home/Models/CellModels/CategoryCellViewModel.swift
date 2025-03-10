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
            UIImage.monitor,
            UIImage.playStation,
            UIImage.airpods,
            UIImage.earphones
        ], count: 103),
        
        CategoryCellViewModel(id: 1, name: "Clothing", images: [
            UIImage.clothing1,
            UIImage.clothing2,
            UIImage.clothing3,
            UIImage.clothing4
        ], count: 5),
        
        CategoryCellViewModel(id: 2, name: "Home goods", images: [
            UIImage.candles,
            UIImage.blanket,
            UIImage.coffee,
            UIImage.mixer
        ], count: 200),
        
        CategoryCellViewModel(id: 3, name: "Sports", images: [
            UIImage.sport1,
            UIImage.sport2,
            UIImage.sport4,
            UIImage.sport3
        ], count: 2000)
    ]
}
