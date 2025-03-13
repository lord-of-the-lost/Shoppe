//
//  AdressView.swift
//  Shoppe
//
//  Created by Daniil Murzin on 09.03.2025.
//

import UIKit

enum PaymentInfoType {
    case shipping
    case contact
    
    var title: String {
        switch self {
        case .shipping: return "Shipping Address"
        case .contact: return "Contact Information"
        }
    }
    
    var details: String {
        switch self {
        case .shipping: return "26, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city"
        case .contact: return "+84932000000\namandamorgan@example.com"
        }
    }
}

final class PaymentInformationView: UIView {
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = Fonts.nunitoRegular.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, infoLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(type: PaymentInfoType) {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        titleLabel.text = type.title
        infoLabel.text = type.details
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension PaymentInformationView {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .customLightGray
        layer.cornerRadius = 10
        
        addSubview(stackView)
        addSubview(editButton)
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -40),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            editButton.topAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -2),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func editButtonTapped() {
        
    }
}
