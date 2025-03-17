//
//  AdressView.swift
//  Shoppe
//
//  Created by Надежда Капацина on 09.03.2025.
//

import UIKit

protocol AddressViewDelegate: AnyObject {
    func editAddressTapped()
}

final class AddressView: UIView {
    weak var delegate: AddressViewDelegate?
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shipping Address"
        label.font = Fonts.ralewayBold.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "26, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = Fonts.nunitoRegular.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(.pen, for: .normal)
        button.tintColor = .systemBlue
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with address: String) {
        addressLabel.text = address
    }
}

// MARK: - Private Methods

private extension AddressView {
     func setupView() {
         backgroundColor = .customLightGray
         layer.cornerRadius = 10
         
         addSubview(stackView)
         stackView.addArrangedSubview(titleLabel)
         stackView.addArrangedSubview(addressLabel)
         addSubview(editButton)
         
         editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

     }
    
    func setupConstraints() {
            NSLayoutConstraint.activate([
                // StackView constraints
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -40),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
                
                // EditButton constraints
                editButton.centerYAnchor.constraint(equalTo: addressLabel.centerYAnchor),
                editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                editButton.widthAnchor.constraint(equalToConstant: 30),
                editButton.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
        
        @objc func editButtonTapped() {
            delegate?.editAddressTapped()
        }
    }




