//
//  JustForYouCell.swift
//  Shoppe
//
//  Created by Daniil Murzin on 05.03.2025.
//

import UIKit

final class JustForYouCell: UICollectionViewCell {
    
    // MARK: - Drawings
    private enum Drawings {
        static let cornerRadius: CGFloat = 10
        static let addButtonCornerRadius: CGFloat = 4
        static let addButtonHeightMultiplier: CGFloat = 0.2
        static let descriptionTopSpacing: CGFloat = 10
        static let addButtonTopSpacing: CGFloat = 8
        static let zeroSpacing: CGFloat = 0.0

        static let addButtonText = "Add to cart"
    }
    
    // MARK: - Properties
    static let identifier = JustForYouCell.description()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = Drawings.cornerRadius
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.nunitoRegular
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle(Drawings.addButtonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.baseFont12
        button.backgroundColor = .customBlue
        button.layer.cornerRadius = Drawings.addButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var wishButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.heartFill, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ConfigurableViewProtocol
extension JustForYouCell: ConfigurableViewProtocol {
    func configure(with model: JustForYourCellViewModel) {
        imageView.image = model.image
        descriptionLabel.text = model.description
        priceLabel.text = model.price
    }
}

// MARK: - Private Methods
private extension JustForYouCell {
    func setupUI() {
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(priceStackView)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(wishButton)
        addSubview(addButton)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Drawings.descriptionTopSpacing),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 60),
            
            
            priceStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            priceStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            priceStackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            priceStackView.heightAnchor.constraint(equalToConstant: 30),
            
            addButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Drawings.addButtonTopSpacing),
            addButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

