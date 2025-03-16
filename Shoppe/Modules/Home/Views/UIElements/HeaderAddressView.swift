import UIKit

protocol HeaderAddressViewDelegate: AnyObject {
    func addressTapped()
}

final class HeaderAddressView: UIView {
    weak var delegate: HeaderAddressViewDelegate?
    
    // MARK: - Drawings
    private enum Drawings {
        static let badgeSize: CGFloat = 11.0

        static let addressTopSpacing: CGFloat = -8.0
        static let addressLeadingSpacing: CGFloat = -12.0
        static let imagePadding: CGFloat = 4.0

        static let deliveryText = "Delivery address"
        static let addressText = "Salatiga City, Central Java"
        static let badgeText = "2"

        static let deliveryTextColor: UIColor = .gray
        static let addressTextColor: UIColor = .black
        static let badgeTextColor: UIColor = .white
        static let badgeBackgroundColor: UIColor = UIColor.customRed
    }

    // MARK: - UI Elements
    private lazy var deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = Drawings.deliveryText
        label.font = Fonts.baseFont10
        label.textColor = Drawings.deliveryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Drawings.addressTextColor
        config.image = UIImage.chevron
        config.imagePlacement = .trailing
        config.imagePadding = Drawings.imagePadding
        config.attributedTitle = AttributedString(
            Drawings.addressText,
            attributes: AttributeContainer([.font: Fonts.baseFontMedium12])
        )
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(addressButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "cart")
        button.setImage(image, for: .normal)
        button.tintColor = Drawings.addressTextColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.text = Drawings.badgeText
        label.font = Fonts.baseFont7Bold
        label.textColor = Drawings.badgeTextColor
        label.textAlignment = .center
        label.backgroundColor = Drawings.badgeBackgroundColor
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
private extension HeaderAddressView {
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
    
    @objc func addressButtonTapped() {
        delegate?.addressTapped()
    }
}
