//
//  PaymentMethodView.swift
//  Shoppe
//
//  Created by Daniil Murzin on 12.03.2025.
//


import UIKit

final class PaymentMethodView: UIView {
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment Method"
        label.font = Fonts.ralewayBold21
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Card", for: .normal)
        button.setTitleColor(UIColor.customBlueText, for: .normal)
        button.titleLabel?.font = Fonts.ralewayBold15
        button.backgroundColor = UIColor.customLightGray
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(.pen1, for: .normal)
        button.tintColor = .systemBlue
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
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
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            editButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            editButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30),

            cardButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            cardButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            cardButton.widthAnchor.constraint(equalToConstant: 80),
            cardButton.heightAnchor.constraint(equalToConstant: 35),
            cardButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
