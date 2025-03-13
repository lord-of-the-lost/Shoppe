//
//  UIStackView+Extension.swift
//  Shoppe
//
//  Created by Николай Игнатов on 10.03.2025.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
