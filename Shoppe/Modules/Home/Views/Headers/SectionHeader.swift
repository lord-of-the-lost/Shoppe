//
//  SectionHeader.swift
//  Shoppe
//
//  Created by Daniil Murzin on 09.03.2025.
//


import UIKit

final class SectionHeader: UICollectionReusableView {
    
    // MARK: - Constants
    private enum Drawings {
        static let horizontalSpacing: CGFloat = 10
    }
    
    static let identifier = SectionHeader.description()
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold.withSize(21)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let seeAllButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage.seeAllButton
        config.imagePlacement = .trailing
        config.baseForegroundColor = .black
        config.imagePadding = 4
        config.attributedTitle = AttributedString(
            "See All",
            attributes: AttributeContainer([.font: Fonts.ralewayBold.withSize(15)])
        )
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private var action: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(_ model: HeaderViewModel) {
        titleLabel.text = model.title
        seeAllButton.isHidden = model.isHidden
        self.action = model.action
        
        seeAllButton.addTarget(self, action: #selector(handleSeeAllButtonTap), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        addSubview(titleLabel)
        addSubview(seeAllButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Drawings.horizontalSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Drawings.horizontalSpacing),
            seeAllButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func handleSeeAllButtonTap() {
        action?()
    }
}
