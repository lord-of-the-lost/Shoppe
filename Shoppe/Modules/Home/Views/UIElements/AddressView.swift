import UIKit

final class AddressView: UIView {
    
    // MARK: - Constants
    private enum Drawings {
        static let deliveryFontSize: CGFloat = 10
        static let addressFontSize: CGFloat = 12
        static let badgeFontSize: CGFloat = 7
        static let badgeSize: CGFloat = 11
        static let addressTopSpacing: CGFloat = -8
        static let addressLeadingSpacing: CGFloat = -12
    }

    // MARK: - UI Elements
    private let deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = "Delivery address"
        label.font = UIFont.systemFont(ofSize: Drawings.deliveryFontSize, weight: .regular)
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
            attributes: AttributeContainer([.font: UIFont.systemFont(
                ofSize: Drawings.addressFontSize, weight: .medium)])
        )
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cartButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "cart")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.font = UIFont.systemFont(ofSize: Drawings.badgeFontSize, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.customRed
        label.layer.cornerRadius = Drawings.badgeSize / 2
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
            
            addressButton.topAnchor.constraint(
                equalTo: deliveryLabel.bottomAnchor,
                constant: Drawings.addressTopSpacing
            ),
            addressButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Drawings.addressLeadingSpacing
            ),
            addressButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cartButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            badgeLabel.topAnchor.constraint(equalTo: cartButton.topAnchor),
            badgeLabel.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor),
            badgeLabel.widthAnchor.constraint(equalToConstant: Drawings.badgeSize),
            badgeLabel.heightAnchor.constraint(equalToConstant: Drawings.badgeSize)
        ])
    }
}
