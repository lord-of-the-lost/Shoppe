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
        static let cornerRadius: CGFloat = 10.0
        static let shadowOffset: CGSize = CGSize(width: 0, height: 10)
        static let shadowOpacity: Float = 0.1
        static let shadowRadius: CGFloat = 4
        static let cellPadding: CGFloat = 8
        static let spacing: CGFloat = 8.0
        static let priceFontSize: CGFloat = 18.0
        static let descriptionFontSize: CGFloat = 14.0
    }
    
    private let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = Drawings.shadowOffset
        view.layer.shadowOpacity = Drawings.shadowOpacity
        view.layer.shadowRadius = Drawings.shadowRadius
        view.layer.cornerRadius = Drawings.cornerRadius
        view.layer.masksToBounds = false
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Drawings.cornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.nunitoRegular
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold.withSize(Drawings.priceFontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = false
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
        addSubview(shadowView)
        shadowView.addSubview(productImageView)
        addSubview(descriptionLabel)
        addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: Drawings.cellPadding),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Drawings.cellPadding),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Drawings.cellPadding),
            shadowView.heightAnchor.constraint(equalTo: shadowView.widthAnchor),

            productImageView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 2),
            productImageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 2),
            productImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -2),
            productImageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -2),

            descriptionLabel.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: Drawings.spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Drawings.cellPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Drawings.cellPadding),

            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Drawings.spacing / 2),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Drawings.cellPadding),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Drawings.cellPadding)
        ])
    }
}

// MARK: - SwiftUI Preview
struct PopularCell_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            PopularCellViewWrapper(model: PopularMock.all.first!)
                .previewLayout(.sizeThatFits)
                .padding()
                .frame(width: 180, height: 250)
        }
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

