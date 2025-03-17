//
//  Untitled.swift
//  Shoppe
//
//  Created by Надежда Капацина on 11.03.2025.
//
import Foundation

extension Double {
    func formattedAsPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: self)) ?? "$\(self)"
    }
}

extension Double {
    func formattedAsPrice(currency: Currency) -> String {
        currency.formatPrice(self)
    }
}
