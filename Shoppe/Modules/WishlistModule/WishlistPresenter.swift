//
//  WishlistPresenter.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 06.03.2025.
//

import UIKit

struct ProductDataModel {
    let image: UIImage?
    let description: String
    let price: String
}

protocol WishlistPresenterProtocol {
    func getProductsCount() -> Int
    func getProduct(at index: Int) -> ProductDataModel?
    func didTapProduct(at index: Int)
    func addToCartProduct(at index: Int)
    func toggleProductLike(at index: Int)
}

final class WishlistPresenter {
    private weak var view: WishlistViewProtocol?
    private var products: [ProductDataModel] = []

    func setupView(_ view: WishlistViewProtocol) {
        self.view = view
        loadProducts()
    }
    
    func loadProducts() {
        products = [
            ProductDataModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductDataModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductDataModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductDataModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductDataModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductDataModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
            ProductDataModel(image: UIImage(named: "product"), description: "Lorem ipsum dolor sit amet consectetur", price: "$17,00"),
        ]
        print("Loaded \(products.count) products")
        view?.reloadData()
    }
}

// MARK: - WishlistPresenterProtocol
extension WishlistPresenter: WishlistPresenterProtocol {
    func getProductsCount() -> Int {
        products.count
    }
    
    func getProduct(at index: Int) -> ProductDataModel? {
        products[safe: index]
    }
    
    func didTapProduct(at index: Int) {
        print(index)
    }
    
    func addToCartProduct(at index: Int) {
        print(index)
    }
    
    func toggleProductLike(at index: Int) {
        print(index)
    }
}
