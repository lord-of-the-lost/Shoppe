//
//  SearchBarView.swift
//  Shoppe
//
//  Created by Daniil Murzin on 06.03.2025.
//

import UIKit

final class SearchBarView: UIView {
    
    private let searchField: UITextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Search"
        textField.font = Fonts.ralewayMedium.withSize(16)
        textField.textColor = UIColor.customGrayLighterText
        textField.backgroundColor = UIColor.customLightGray
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: topAnchor),
            searchField.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.widthAnchor.constraint(equalToConstant: 245)
        ])
    }
}

final class PaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
