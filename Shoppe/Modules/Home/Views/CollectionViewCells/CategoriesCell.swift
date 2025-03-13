//
//  CatagoriesCell.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//

import UIKit
import SwiftUI

final class CategoriesCell: UICollectionViewCell {

    // MARK: - Drawings
    private enum Drawings {
        
        static let imageCount = 4
        static let gridSize = 2
        static let imageCornerRadius: CGFloat = 5
        static let imageSpacing: CGFloat = 4
        
        static let stackSpacing: CGFloat = 8
        static let textTopPadding: CGFloat = 8
        
        static let countLabelCornerRadius: CGFloat = 6
        static let countLabelWidth: CGFloat = 40
        static let countLabelHeight: CGFloat = 24
        
        static let shadowOffset: CGSize = CGSize(width: 0, height: 10)
        static let shadowOpacity: Float = 0.102
        static let shadowRadius: CGFloat = 10
        
        static let cellCornerRadius: CGFloat = 10
        static let cellPadding: CGFloat = 8
    }
    
    // MARK: - Properties
    static let identifier = CategoriesCell.description()
    
    // MARK: - UI
    private lazy var imagesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Drawings.imageCornerRadius
        return view
    }()
    
    private lazy var imageViews: [UIImageView] = (0..<Drawings.imageCount).map { _ in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Drawings.imageCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Drawings.stackSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold17
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold12
        label.textColor = .customBlack
        label.textAlignment = .center
        label.backgroundColor = .customBlueForHome
        label.layer.cornerRadius = Drawings.countLabelCornerRadius
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutImageViews()
    }
}

// MARK: - ConfigurableViewProtocol
extension CategoriesCell: ConfigurableViewProtocol {
    func configure(with model: CategoryCellViewModel) {
        titleLabel.text = model.name
        countLabel.text = "\(model.count)"
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.image = index < model.images.count ? model.images[index] : nil
        }
    }
}

// MARK: - Private Methods
private extension CategoriesCell {
    
    func layoutImageViews() {
        let imageSize = (contentView.frame.width - (2 * Drawings.cellPadding) - Drawings.imageSpacing) / CGFloat(Drawings.gridSize)
        
        for (index, imageView) in imageViews.enumerated() {
            let row = index / Drawings.gridSize
            let col = index % Drawings.gridSize
            
            imageView.frame = CGRect(
                x: CGFloat(col) * (imageSize + Drawings.imageSpacing),
                y: CGFloat(row) * (imageSize + Drawings.imageSpacing),
                width: imageSize,
                height: imageSize
            )
        }
    }
    
    func setupViews() {
        contentView.addSubview(imagesContainerView)
        contentView.addSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(countLabel)
        imageViews.forEach { imagesContainerView.addSubview($0) }
        contentView.layer.cornerRadius = Drawings.cellCornerRadius
    }
    
    func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = Drawings.shadowOffset
        layer.shadowOpacity = Drawings.shadowOpacity
        layer.shadowRadius = Drawings.shadowRadius
        layer.masksToBounds = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Drawings.cellPadding),
            imagesContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawings.cellPadding),
            imagesContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Drawings.cellPadding),
            imagesContainerView.heightAnchor.constraint(equalTo: contentView.widthAnchor, constant: -2 * Drawings.cellPadding),
            
            textStackView.topAnchor.constraint(equalTo: imagesContainerView.bottomAnchor, constant: Drawings.textTopPadding),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawings.cellPadding),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Drawings.cellPadding),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Drawings.cellPadding),
            
            countLabel.widthAnchor.constraint(equalToConstant: Drawings.countLabelWidth),
            countLabel.heightAnchor.constraint(equalToConstant: Drawings.countLabelHeight)
        ])
    }
}

// MARK: - SwiftUI Preview for UIKit View
struct CategoriesCell_Preview: PreviewProvider {
    static var previews: some View {
        CategoriesCellViewWrapper(category: Categories.all.first!)
            .previewLayout(.sizeThatFits)
            .padding()
            .frame(width: 165, height: 192)
    }
}

struct CategoriesCellViewWrapper: UIViewRepresentable {
    let category: CategoryCellViewModel
    
    func makeUIView(context: Context) -> CategoriesCell {
        let cell = CategoriesCell()
        cell.configure(with: category)
        return cell
    }
    
    func updateUIView(_ uiView: CategoriesCell, context: Context) {
        uiView.configure(with: category)
    }
}
