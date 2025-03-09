//
//  JustForYouCell.swift
//  Shoppe
//
//  Created by Daniil Murzin on 05.03.2025.
//

import UIKit
import SwiftUI

final class JustForYouCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = JustForYouCell.description()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.nunitoRegular
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold.withSize(17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = .customBlue
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let wishButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heartFill"), for: .normal)
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
extension JustForYouCell: ConfigurableViewProtocol {
    func configure(with model: JustForYourCellViewModel) {
        imageView.image = model.image
        descriptionLabel.text = model.description
        priceLabel.text = model.price
    }
}

// MARK: - Private Methods
private extension JustForYouCell {
    func setupUI() {
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(priceStackView)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(wishButton)
        addSubview(addButton)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            
            priceStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            priceStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            priceStackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            
            addButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            addButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2)
        ])
    }
}


struct JustForYouCell_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            JustForYouCellViewWrapper(model: JustForYouMock.all.first!)
                .previewLayout(.sizeThatFits)
                .padding()
                .frame(width: 160, height: 279)
        }
    }
}

struct JustForYouCellViewWrapper: UIViewRepresentable {
    let model: JustForYourCellViewModel
    
    func makeUIView(context: Context) -> JustForYouCell {
        let cell = JustForYouCell()
        cell.configure(with: model)
        return cell
    }
    
    func updateUIView(_ uiView: JustForYouCell, context: Context) {
        uiView.configure(with: model)
    }
}
