//
//  PopularCell.swift
//  Shoppe
//
//  Created by Daniil Murzin on 05.03.2025.
//

import UIKit

final class PopularCell: UICollectionViewCell {
    
    static let identifier = PopularCell.description()
    
    // MARK: - Drawings
    private enum Drawings {
        static let cornerRadius: CGFloat = 10.0
        
        static let shadowOffset: CGSize = CGSize(width: 0, height: 10)
        static let shadowOpacity: Float = 0.1
        static let shadowRadius: CGFloat = 4
        static let cellPadding: CGFloat = 8
        
        static let spacing: CGFloat = 8.0
    }
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = Drawings.shadowOffset
        view.layer.shadowOpacity = Drawings.shadowOpacity
        view.layer.shadowRadius = Drawings.shadowRadius
        view.layer.cornerRadius = Drawings.cornerRadius
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Drawings.cornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.nunitoRegular
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold18
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = false
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: PopularCellViewModel) {
        productImageView.image = model.image
        descriptionLabel.text = model.description
        priceLabel.text = model.price
    }
    
    private func setupViews() {
        addSubview(shadowView)
        shadowView.addSubview(productImageView)
        addSubview(descriptionLabel)
        addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: Drawings.cellPadding),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Drawings.cellPadding),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Drawings.cellPadding),
            shadowView.heightAnchor.constraint(equalTo: shadowView.widthAnchor),

            productImageView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 2),
            productImageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 2),
            productImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -2),
            productImageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -2),

            descriptionLabel.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: Drawings.spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Drawings.cellPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Drawings.cellPadding),

            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Drawings.spacing / 2),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Drawings.cellPadding),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Drawings.cellPadding)
        ])
    }
}
