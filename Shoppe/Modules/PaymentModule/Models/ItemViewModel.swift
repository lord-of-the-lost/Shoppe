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
