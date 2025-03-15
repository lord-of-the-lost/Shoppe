//
//  ItemTableViewCell.swift
//  Shoppe
//
//  Created by Daniil Murzin on 11.03.2025.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    //MARK: - Drawing

    private enum Drawings {
        static let imageContainerSize: CGFloat = 60
        static let imageCornerRadius: CGFloat = 30
        static let badgeContainerSize: CGFloat = 25
        static let badgeSize: CGFloat = 22
        static let badgeCornerRadius: CGFloat = 11
        static let titlePadding: CGFloat = 12
        static let priceMaxWidth: CGFloat = 80
        static let priceTrailing: CGFloat = -16
        static let cellPadding: CGFloat = 16
        static let shadowOffset: CGSize = CGSize(width: 0, height: 4)
        static let shadowRadius: CGFloat = 6
        static let shadowOpacity: Float = 0.2
    }
    
    static let reuseIdentifier: String = ItemTableViewCell.description()
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = Drawings.shadowOffset
        view.layer.shadowOpacity = Drawings.shadowOpacity
        view.layer.shadowRadius = Drawings.shadowRadius
        view.layer.cornerRadius = Drawings.imageCornerRadius
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var imagesContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Drawings.imageCornerRadius
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Drawings.imageCornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var badgeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Drawings.badgeCornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold15
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = UIColor.customLightBlue
        label.layer.cornerRadius = Drawings.badgeCornerRadius
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.nunitoRegular
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold18
        label.textColor = .black
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layer.masksToBounds = false
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: CartItem) {
        cellImage.image = UIImage(named: model.imageName)
        titleLabel.text = model.name
        priceLabel.text = String(format: "$%.2f", model.price)
        badgeLabel.text = String(model.quantity)
    }
}

private extension ItemTableViewCell {
    func setupView() {
        contentView.addSubview(shadowView)
        shadowView.addSubview(imagesContainerView)
        imagesContainerView.addSubview(cellImage)
        contentView.addSubview(badgeContainerView)
        badgeContainerView.addSubview(badgeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawings.cellPadding),
            shadowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shadowView.widthAnchor.constraint(equalToConstant: Drawings.imageContainerSize),
            shadowView.heightAnchor.constraint(equalToConstant: Drawings.imageContainerSize),
            
            imagesContainerView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            imagesContainerView.centerYAnchor.constraint(equalTo: shadowView.centerYAnchor),
            imagesContainerView.widthAnchor.constraint(equalTo: shadowView.widthAnchor),
            imagesContainerView.heightAnchor.constraint(equalTo: shadowView.heightAnchor),
            
            cellImage.centerXAnchor.constraint(equalTo: imagesContainerView.centerXAnchor),
            cellImage.centerYAnchor.constraint(equalTo: imagesContainerView.centerYAnchor),
            cellImage.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor),
            cellImage.heightAnchor.constraint(equalTo: imagesContainerView.heightAnchor),
            
            badgeContainerView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor, constant: 1),
            badgeContainerView.leadingAnchor.constraint(equalTo: imagesContainerView.trailingAnchor, constant: -Drawings.badgeContainerSize),
            badgeContainerView.widthAnchor.constraint(equalToConstant: Drawings.badgeContainerSize),
            badgeContainerView.heightAnchor.constraint(equalToConstant: Drawings.badgeContainerSize),
            
            badgeLabel.centerXAnchor.constraint(equalTo: badgeContainerView.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeContainerView.centerYAnchor),
            badgeLabel.widthAnchor.constraint(equalToConstant: Drawings.badgeSize),
            badgeLabel.heightAnchor.constraint(equalToConstant: Drawings.badgeSize),
            
            titleLabel.leadingAnchor.constraint(equalTo: imagesContainerView.trailingAnchor, constant: Drawings.titlePadding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -Drawings.titlePadding),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Drawings.priceTrailing),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.widthAnchor.constraint(lessThanOrEqualToConstant: Drawings.priceMaxWidth)
        ])
    }
}
