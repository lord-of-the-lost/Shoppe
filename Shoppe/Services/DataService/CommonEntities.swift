//
//  CommonEntities.swift
//  Shoppe
//
//  Created by Николай Игнатов on 08.03.2025.
//

import UIKit

struct UserData {
    var id: String = UUID().uuidString
    var name: String = "Anonimus"
    var email: String = .init()
    var password: String = .init()
    var address: String = "Delivery address"
    var currentCurrency: Currency = .ruble
    var cart: [Product] = .init()
    var wishList: [Product] = .init()
    var serachHistory: [String] = .init()
    var isOnboardingComplete: Bool = false
    var isAuthorized: Bool = false
}

struct Product {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    let image: UIImage
    var count: Int = 1
    var isInCart: Bool = false
    var isInWishlist: Bool = false
    
    enum Category: String {
        case electronics = "electronics"
        case jewelery = "jewelery"
        case mensClothing = "men's clothing"
        case womensClothing = "women's clothing"
        case other
    }
}

enum Currency {
    case ruble, dollar, euro
}
