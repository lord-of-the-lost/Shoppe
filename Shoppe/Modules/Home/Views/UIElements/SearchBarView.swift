//
//  SearchBarView.swift
//  Shoppe
//
//  Created by Daniil Murzin on 06.03.2025.
//

import UIKit

final class SearchBarView: UIView {
    private lazy var searchField: UITextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Search"
        textField.font = Fonts.ralewayMedium16
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
