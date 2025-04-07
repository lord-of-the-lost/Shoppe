//
//  HeaderViewModel.swift
//  Shoppe
//
//  Created by Daniil Murzin on 09.03.2025.
//

import Foundation

struct HeaderViewModel: Equatable, Hashable {
    
    let title: String
    let action: () -> Void
    let isHidden: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(isHidden)
    }
    
    static func == (lhs: HeaderViewModel, rhs: HeaderViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.isHidden == rhs.isHidden
    }
}
