//
//  CheckoutFooterView.swift
//  Shoppe
//
//  Created by Надежда Капацина on 11.03.2025.
//

import UIKit

final class CheckoutFooterView: UIView {
    var checkoutHandler: (() -> Void)?
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.ralewayExtraBold.withSize(20)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Checkout", for: .normal)
        button.backgroundColor = .customBlue
        button.layer.cornerRadius = 11
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(total: String) {
        totalLabel.text = total
    }
    
}
// MARK: - Private Methods

private extension CheckoutFooterView {
    
    func setupViews() {
        backgroundColor = .customLightGray
        
        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [totalLabel, checkoutButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        guard let stackView = subviews.first else { return }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            checkoutButton.heightAnchor.constraint(equalToConstant: 40),
            checkoutButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 128)
        ])
    }
    
    @objc func checkoutTapped() {
        checkoutHandler?()
    }
}
