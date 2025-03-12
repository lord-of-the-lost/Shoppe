
//  Shoppe
//
//  Created by Надежда Капацина on 11.03.2025.
//
import UIKit

final class CartItemCell: UITableViewCell {
    static let reuseID = "CartItemCell"
    
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
    
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.nunitoRegular.withSize(12)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayMedium.withSize(14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold.withSize(18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rabbish"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let quantityStepper = QuantityStepper()
    
    var deleteHandler: (() -> Void)?
    var increaseHandler: (() -> Void)?
    var decreaseHandler: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: CartItem) {
        productImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.name
        detailsLabel.text = "\(item.color), \(item.size)"
        priceLabel.text = item.price.formattedAsPrice()
        quantityStepper.setQuantity(item.quantity)
    }
}

// MARK: - Private Methods
private extension CartItemCell {
    func setupViews() {
        quantityStepper.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shadowView)
        shadowView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(quantityStepper)
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        quantityStepper.increaseAction = { [weak self] in self?.increaseHandler?() }
        quantityStepper.decreaseAction = { [weak self] in self?.decreaseHandler?() }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Shadow View
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            shadowView.widthAnchor.constraint(equalToConstant: 130),
            shadowView.heightAnchor.constraint(equalToConstant: 110),
            
            // Product Image
            productImageView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 4),
            productImageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 4),
            productImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -4),
            productImageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -4),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: shadowView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            // Details Label
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Price Label
            priceLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            // Quantity Stepper
            quantityStepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quantityStepper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Delete Button
            deleteButton.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -8),
            deleteButton.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 8),
            deleteButton.widthAnchor.constraint(equalToConstant: 35),
            deleteButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    @objc func deleteTapped() {
        deleteHandler?()
    }
}

