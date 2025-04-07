//
//  ShippingOptionCell.swift
//  Shoppe
//
//  Created by Daniil Murzin on 12.03.2025.
//

import UIKit

class ShippingOptionCell: UITableViewCell {
    
    // MARK: - UI Elements
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.shippingCheck
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold18
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deliveryTimeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayMedium13
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Mock Data
    
    func setMockData(title: String, deliveryTime: String, price: String) {
        titleLabel.text = title
        deliveryTimeLabel.text = deliveryTime
        priceLabel.text = price
    }
    
    // MARK: - Set Selected State
    
    func setSelectedState(_ isSelected: Bool) {
        checkmarkImageView.isHidden = !isSelected
        containerView.backgroundColor = isSelected ? UIColor.customLightBlue : UIColor.systemGray6
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubview(checkmarkImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(deliveryTimeLabel)
        containerView.addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            checkmarkImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            checkmarkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 22),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 22),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            deliveryTimeLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            deliveryTimeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            priceLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
