//
//  PaymentMethodView.swift
//  Shoppe
//
//  Created by Daniil Murzin on 12.03.2025.
//


import UIKit

final class PaymentMethodView: UIView {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment Method"
        label.font = Fonts.ralewayBold21
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Card", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = UIColor.systemGray5
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage.pen1
        button.setImage(image, for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(cardButton)
        addSubview(editButton)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            editButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            editButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30),

            cardButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            cardButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardButton.widthAnchor.constraint(equalToConstant: 80),
            cardButton.heightAnchor.constraint(equalToConstant: 35),
            cardButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
