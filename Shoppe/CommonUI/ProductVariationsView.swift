//
//  ProductVariationsView.swift
//  Shoppe
//
//  Created by Николай Игнатов on 09.03.2025.
//

import UIKit

final class ProductVariationsView: UIView {
    private lazy var variationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Variations"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorChipsView: ChipsView = {
        let chipsView = ChipsView(cornerRadius: 4)
        chipsView.configure(with: "Pink")
        chipsView.translatesAutoresizingMaskIntoConstraints = false
        return chipsView
    }()
    
    private lazy var sizeChipsView: ChipsView = {
        let chipsView = ChipsView(cornerRadius: 4)
        chipsView.configure(with: "M")
        chipsView.translatesAutoresizingMaskIntoConstraints = false
        return chipsView
    }()
    
    private lazy var firstImageView: UIImageView = {
        let image = UIImage(resource: .product)
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var secondImageView: UIImageView = {
        let image = UIImage(resource: .product)
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var thirdImageView: UIImageView = {
        let image = UIImage(resource: .product)
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension ProductVariationsView {
    func setupView() {
        addSubview(variationsLabel)
        addSubview(colorChipsView)
        addSubview(sizeChipsView)
        addSubview(firstImageView)
        addSubview(secondImageView)
        addSubview(thirdImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            variationsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            variationsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            colorChipsView.centerYAnchor.constraint(equalTo: variationsLabel.centerYAnchor),
            colorChipsView.leadingAnchor.constraint(equalTo: variationsLabel.trailingAnchor, constant: 9),
            colorChipsView.heightAnchor.constraint(equalToConstant: 25),
            
            sizeChipsView.centerYAnchor.constraint(equalTo: variationsLabel.centerYAnchor),
            sizeChipsView.leadingAnchor.constraint(equalTo: colorChipsView.trailingAnchor, constant: 6),
            sizeChipsView.heightAnchor.constraint(equalToConstant: 25),
            sizeChipsView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            firstImageView.topAnchor.constraint(equalTo: sizeChipsView.bottomAnchor, constant: 14),
            firstImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstImageView.heightAnchor.constraint(equalToConstant: 75),
            firstImageView.widthAnchor.constraint(equalToConstant: 75),
            
            secondImageView.topAnchor.constraint(equalTo: sizeChipsView.bottomAnchor, constant: 14),
            secondImageView.leadingAnchor.constraint(equalTo: firstImageView.trailingAnchor, constant: 6),
            secondImageView.heightAnchor.constraint(equalToConstant: 75),
            secondImageView.widthAnchor.constraint(equalToConstant: 75),
            
            thirdImageView.topAnchor.constraint(equalTo: sizeChipsView.bottomAnchor, constant: 14),
            thirdImageView.leadingAnchor.constraint(equalTo: secondImageView.trailingAnchor, constant: 6),
            thirdImageView.heightAnchor.constraint(equalToConstant: 75),
            thirdImageView.widthAnchor.constraint(equalToConstant: 75),
        ])
    }
}
