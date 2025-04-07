//
//  ProductModel.swift
//  Shoppe
//
//  Created by Николай Игнатов on 07.03.2025.
//

struct ProductModel: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    let image: String
    
    enum Category: String, Codable {
       case electronics = "electronics"
       case jewelery = "jewelery"
       case mensClothing = "men's clothing"
       case womensClothing = "women's clothing"
       case other
    }
}
