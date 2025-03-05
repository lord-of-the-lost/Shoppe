//
//  PopularCell.swift
//  Shoppe
//
//  Created by Daniil Murzin on 05.03.2025.
//

import UIKit
import SwiftUI

final class PopularCell: UICollectionViewCell {
    
    static let identifier = PopularCell.description()
    
    // MARK: - Drawings
    private enum Drawings {
        static let cornerRadius: CGFloat = 12.0
        static let padding: CGFloat = 10.0
        static let spacing: CGFloat = 8.0
        static let priceFontSize: CGFloat = 18.0
        static let descriptionFontSize: CGFloat = 14.0
    }
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Drawings.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Drawings.descriptionFontSize, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Drawings.priceFontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: PopularCellViewModel) {
        productImageView.image = model.image
        descriptionLabel.text = model.description
        priceLabel.text = String(format: "$%.2f", model.price)
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = Drawings.cornerRadius
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        contentView.addSubview(productImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Drawings.padding),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawings.padding),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Drawings.padding),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: Drawings.spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawings.padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Drawings.padding),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Drawings.spacing / 2),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawings.padding),
        ])
    }
}

// MARK: - SwiftUI Preview
struct PopularCell_Preview: PreviewProvider {
    static var previews: some View {
        PopularCellViewWrapper(model: PopularMock.all.first!)
            .previewLayout(.sizeThatFits)
            .padding()
            .frame(width: 180, height: 250)
    }
}

struct PopularCellViewWrapper: UIViewRepresentable {
    let model: PopularCellViewModel
    
    func makeUIView(context: Context) -> PopularCell {
        let cell = PopularCell()
        cell.configure(with: model)
        return cell
    }
    
    func updateUIView(_ uiView: PopularCell, context: Context) {
        uiView.configure(with: model)
    }
}
