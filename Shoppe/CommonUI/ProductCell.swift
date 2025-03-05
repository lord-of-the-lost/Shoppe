//
//  ProductCell.swift
//  Shoppe
//
//  Created by Николай Игнатов on 03.03.2025.
//

import UIKit

class ProductCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = ProductCell.description()
    
    private let shadowView: UIView = {
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
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "product")
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet consectetur"
        label.font = Fonts.nunitoRegular
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var priceLabel: UILabel = {
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var wishButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heartFill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAction()
        setupUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func setAction() {        
    }

    func configureCell(image: UIImage?, description: String, price: String) {
        imageView.image = image
        descriptionLabel.text = description
        priceLabel.text = price
    }
}
// MARK: - Extensions Constraint
private extension ProductCell {
     func setupUI() {
        addSubview(shadowView)
        shadowView.addSubview(imageView)
        [descriptionLabel,
         priceLabel,
         addButton,
         wishButton
        ].forEach { addSubview($0) }
    }
     func makeConstraints() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            shadowView.heightAnchor.constraint(equalToConstant: 181),
            
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
            
            wishButton.heightAnchor.constraint(equalToConstant: 21),
            wishButton.widthAnchor.constraint(equalToConstant: 22),
            wishButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            wishButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        ])
    }
}
