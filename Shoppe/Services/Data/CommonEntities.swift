//
//  CommonEntities.swift
//  Shoppe
//
//  Created by Николай Игнатов on 08.03.2025.
//

import UIKit

struct User: Codable {
    var id: String = UUID().uuidString
    var name: String = "Anonimus"
    var email: String = .init()
    var password: String = .init()
    var avatarData: Data = .init()
    var address: String = "Калифорния"
    var currentCurrency: Currency = .dollar
    var cart: [Product] = .init()
    var wishList: [Product] = .init()
    var searchHistory: [String] = .init()
    var isOnboardingComplete: Bool = false
    var isAuthorized: Bool = false
}

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    let imageData: Data
    var count: Int = 1
    var isInCart: Bool = false
    var isInWishlist: Bool = false
    
    // Вычисляемое свойство для получения UIImage
    var image: UIImage? {
        UIImage(data: imageData)
    }
    
    enum Category: String, Codable {
        case electronics = "electronics"
        case jewelery = "jewelery"
        case mensClothing = "men's clothing"
        case womensClothing = "women's clothing"
        case other
        
        var displayName: String {
              switch self {
              case .electronics: "Electronics"
              case .jewelery: "Jewelry"
              case .mensClothing: "Men's Clothing"
              case .womensClothing: "Women's Clothing"
              case .other: "Other"
              }
          }
    }
}

enum Currency: Codable {
    case ruble, dollar, euro
    
    var symbol: String {
        switch self {
        case .ruble: "₽"
        case .dollar: "$"
        case .euro: "€"
        }
    }
    
    func formatPrice(_ price: Double) -> String {
        String(format: "\(symbol)%.2f", price)
    }
}
