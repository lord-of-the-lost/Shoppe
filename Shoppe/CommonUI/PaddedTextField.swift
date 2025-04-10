//
//  PaddedTextField.swift
//  Shoppe
//
//  Created by Николай Игнатов on 10.03.2025.
//

import UIKit

final class PaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
