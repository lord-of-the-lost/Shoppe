//
//  ProductCell.swift
//  Shoppe
//
//  Created by Николай Игнатов on 03.03.2025.
//

import UIKit

struct ProductCellViewModel {
    let image: UIImage?
    let description: String
    let price: String
    var isOnCart: Bool = false
    var isOnWishlist: Bool = false
}

protocol ProductCellDelegate: AnyObject {
    func addToCartTapped(_ cell: ProductCell)
    func likeTapped(_ cell: ProductCell)
}

final class ProductCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = ProductCell.description()
    weak var delegate: ProductCellDelegate?
    
    private var isOnCart: Bool = false
    private var isOnWishlist: Bool = false
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "product")
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet consectetur"
        label.font = Fonts.nunitoRegular
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$17,00"
        label.font = Fonts.ralewayBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.backgroundColor = .customBlue
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var wishButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.preferredSymbolConfigurationForImage = .init(pointSize: 24, weight: .regular, scale: .default)
        let button = UIButton()
        button.tintColor = .customRed
        button.configuration = config
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
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
extension ProductCell: ConfigurableViewProtocol {
    func configure(with model: ProductCellViewModel) {
        imageView.image = model.image
        descriptionLabel.text = model.description
        priceLabel.text = model.price
        self.isOnCart = model.isOnCart
        self.isOnWishlist = model.isOnWishlist
        configureAddButton()
        configureLikeButton()
    }
}

// MARK: - Private Methods
private extension ProductCell {
    func setupUI() {
        addSubview(shadowView)
        addSubview(descriptionLabel)
        addSubview(priceLabel)
        addSubview(addButton)
        addSubview(wishButton)
        shadowView.addSubview(imageView)
    }
    
    func configureLikeButton() {
        let image = isOnWishlist ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        wishButton.setImage(image, for: .normal)
    }
    
    func configureAddButton() {
        let text = isOnCart ? "Remove from cart" : "Add to cart"
        addButton.setTitle(text, for: .normal)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            shadowView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            
            imageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 4),
            imageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -4),
            imageView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 4),
            imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -4),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 30),
            descriptionLabel.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: 10),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 50),
            
            addButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: wishButton.leadingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 31),
            
            wishButton.heightAnchor.constraint(equalToConstant: 40),
            wishButton.widthAnchor.constraint(equalToConstant: 40),
            wishButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            wishButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ])
    }
    
    @objc func addButtonTapped() {
        isOnCart.toggle()
        configureAddButton()
        delegate?.addToCartTapped(self)
    }
    
    @objc func likeTapped() {
        isOnWishlist.toggle()
        configureLikeButton()
        delegate?.likeTapped(self)
    }
}
