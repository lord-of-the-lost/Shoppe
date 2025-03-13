//
//  TotalPaymentView.swift
//  Shoppe
//
//  Created by Daniil Murzin on 12.03.2025.
//


import UIKit

final class TotalPaymentView: UIView {
    
    // MARK: - UI Elements
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.font = Fonts.ralewayExtraBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "$34,00"
        label.font = Fonts.ralewayBold18
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pay", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.nunitoLight15
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTotal(to amount: Double) {
        amountLabel.text = String(format: "$%.2f", amount)
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(totalLabel)
        containerView.addSubview(amountLabel)
        containerView.addSubview(payButton)

        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            totalLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            totalLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            amountLabel.leadingAnchor.constraint(equalTo: totalLabel.trailingAnchor, constant: 8),
            amountLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),

            payButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            payButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            payButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            payButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
