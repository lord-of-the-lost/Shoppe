//
//  WishlistPresenter.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 06.03.2025.
//

import Foundation
import UIKit

protocol WishlistPresenterProtocol {
    func loadProducts()
    func didTapAddButton(in cell: ProductCell)
}

final class WishlistPresenter: WishlistPresenterProtocol {
    weak var view: WishlistView?
    private var products: [ProductCellViewModel] = []
    
    init(view: WishlistView) {
        self.view = view
    }
    
    func didTapAddButton(in cell: ProductCell) {
    }
    
    func loadProducts() {
        products = [
            ProductCellViewModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductCellViewModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductCellViewModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductCellViewModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductCellViewModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductCellViewModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductCellViewModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
        ]
        print("Loaded \(products.count) products")
        view?.updateProducts(products)        
    }
}
