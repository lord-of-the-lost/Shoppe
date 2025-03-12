//
//  ItemTableViewCell.swift
//  Shoppe
//
//  Created by Daniil Murzin on 11.03.2025.
//

import UIKit
import SwiftUI

class ItemTableViewCell: UITableViewCell {
    
    //MARK: - Drawing

    private enum Drawings {
        static let imageContainerSize: CGFloat = 60
        static let imageCornerRadius: CGFloat = 30
        static let badgeContainerSize: CGFloat = 25
        static let badgeSize: CGFloat = 22
        static let badgeCornerRadius: CGFloat = 11
        static let titlePadding: CGFloat = 12
        static let priceMaxWidth: CGFloat = 80
        static let priceTrailing: CGFloat = -16
        static let cellPadding: CGFloat = 16
    }
    
    static let reuseIdentifier: String = ItemTableViewCell.description()
    
    private lazy var imagesContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Drawings.imageCornerRadius
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var badgeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Drawings.badgeCornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Drawings.imageCornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold15
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = UIColor.customLightBlue
        label.layer.cornerRadius = Drawings.badgeCornerRadius
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.nunitoRegular
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold18
        label.textColor = .black
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ItemCellViewModel) {
        cellImage.image = model.image
        titleLabel.text = model.description
        priceLabel.text = String(format: "$%.2f", model.price)
        badgeLabel.text = model.quantity
    }
}

private extension ItemTableViewCell {
    func setupView() {
        contentView.addSubview(imagesContainerView)
        imagesContainerView.addSubview(cellImage)
        contentView.addSubview(badgeContainerView)
        badgeContainerView.addSubview(badgeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawings.cellPadding),
            imagesContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imagesContainerView.widthAnchor.constraint(equalToConstant: Drawings.imageContainerSize),
            imagesContainerView.heightAnchor.constraint(equalToConstant: Drawings.imageContainerSize),
            
            cellImage.centerXAnchor.constraint(equalTo: imagesContainerView.centerXAnchor),
            cellImage.centerYAnchor.constraint(equalTo: imagesContainerView.centerYAnchor),
            cellImage.widthAnchor.constraint(equalTo: imagesContainerView.widthAnchor),
            cellImage.heightAnchor.constraint(equalTo: imagesContainerView.heightAnchor),
            
            badgeContainerView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor, constant: 1),
            badgeContainerView.leadingAnchor.constraint(equalTo: imagesContainerView.trailingAnchor, constant: -Drawings.badgeContainerSize),
            badgeContainerView.widthAnchor.constraint(equalToConstant: Drawings.badgeContainerSize),
            badgeContainerView.heightAnchor.constraint(equalToConstant: Drawings.badgeContainerSize),
            
            badgeLabel.centerXAnchor.constraint(equalTo: badgeContainerView.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeContainerView.centerYAnchor),
            badgeLabel.widthAnchor.constraint(equalToConstant: Drawings.badgeSize),
            badgeLabel.heightAnchor.constraint(equalToConstant: Drawings.badgeSize),
            
            titleLabel.leadingAnchor.constraint(equalTo: imagesContainerView.trailingAnchor, constant: Drawings.titlePadding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -Drawings.titlePadding),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Drawings.priceTrailing),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.widthAnchor.constraint(lessThanOrEqualToConstant: Drawings.priceMaxWidth)
        ])
    }
}

struct ItemCell_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            ItemCellViewWrapper(category: ItemCellViewModel(id: 1, image: UIImage.itemCell1, price: 17, description: "Lorem ipsum dolor sit amet consectetur.", quantity: "2"))
                .previewLayout(.sizeThatFits)
                .padding()
                .frame(width: 336, height: 61)
        }
    }
}

struct ItemCellViewWrapper: UIViewRepresentable {
    let category: ItemCellViewModel
    
    func makeUIView(context: Context) -> ItemTableViewCell {
        let cell = ItemTableViewCell()
        cell.configure(with: category)
        return cell
    }
    
    func updateUIView(_ uiView: ItemTableViewCell, context: Context) {
    }
}
