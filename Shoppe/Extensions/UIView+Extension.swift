//
//  UIView+Extension.swift
//  Shoppe
//
//  Created by Николай Игнатов on 10.03.2025.
//


import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
