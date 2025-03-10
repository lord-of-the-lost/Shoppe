//
//  UIViewController+Extension.swift
//  Shoppe
//
//  Created by Николай Игнатов on 10.03.2025.
//


import UIKit

extension UIViewController {
    func addSubviews(_ views: UIView...) {
        views.forEach { view.addSubview($0) }
    }
}
