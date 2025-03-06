import UIKit

final class AddressView: UIView {
    
    // MARK: - UI
    private let deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = "Delivery address"
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        config.image = UIImage.chevron
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.attributedTitle = AttributedString(
            "Salatiga City, Central Java",
            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 12, weight: .medium)])
        )
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cartButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "cart")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemRed
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension AddressView {
    
    func setupView() {
        addSubview(deliveryLabel)
        addSubview(addressButton)
        addSubview(cartButton)
        cartButton.addSubview(badgeLabel)

        NSLayoutConstraint.activate([
            deliveryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            deliveryLabel.topAnchor.constraint(equalTo: topAnchor),
            
            addressButton.topAnchor.constraint(equalTo: deliveryLabel.bottomAnchor, constant: -8),
            addressButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -12),
            addressButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cartButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            badgeLabel.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: -5),
            badgeLabel.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: 5),
            badgeLabel.widthAnchor.constraint(equalToConstant: 20),
            badgeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
