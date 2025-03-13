
//  Shoppe
//
//  Created by Надежда Капацина on 11.03.2025.
//
import UIKit

final class QuantityStepper: UIView {
    var increaseAction: (() -> Void)?
    var decreaseAction: (() -> Void)?
    
    // MARK: - UI Elements
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.ralewayMedium.withSize(16)
        label.backgroundColor = .customLightBlue
        label.layer.cornerRadius = 7
        label.clipsToBounds = true
        return label
    }()
    
    private let decreaseButton: UIButton = {
        let button = UIButton()
        button.setImage(.less, for: .normal)
        button.tintColor = .systemBlue
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let increaseButton: UIButton = {
        let button = UIButton()
        button.setImage(.more, for: .normal)
        button.tintColor = .systemBlue
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setQuantity(_ quantity: Int) {
        quantityLabel.text = "\(quantity)"
    }
}

// MARK: - Private Methods
private extension QuantityStepper {
    func setupViews() {
        layer.borderColor = UIColor.clear.cgColor
        
        decreaseButton.addTarget(self, action: #selector(didTapDecrease), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(didTapIncrease), for: .touchUpInside)
        
        stackView.addArrangedSubview(decreaseButton)
        stackView.addArrangedSubview(quantityLabel)
        stackView.addArrangedSubview(increaseButton)
        
        addSubview(stackView)
    }
    
     func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    @objc func didTapDecrease() {
        decreaseAction?()
    }
    
    @objc func didTapIncrease() {
        increaseAction?()
    }
}
