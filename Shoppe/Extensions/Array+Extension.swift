//
//  Array+Extension.swift
//  Shoppe
//
//  Created by Николай Игнатов on 03.03.2025.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
