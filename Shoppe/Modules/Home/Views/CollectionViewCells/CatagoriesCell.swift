//
//  CatagoriesCell.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//

import UIKit
import SwiftUI



final class CategoriesCell: UICollectionViewCell {

    // MARK: - Drawings (Константы)
    private enum Drawings {
        static let imageCount = 4
        static let gridSize = 2
        static let imageSpacing: CGFloat = 4.0
        static let stackSpacing: CGFloat = 8.0
        static let textTopPadding: CGFloat = 8.0
        static let countLabelCornerRadius: CGFloat = 6.0
        static let countLabelWidth: CGFloat = 40.0
        static let countLabelHeight: CGFloat = 24.0
        static let categoryTitle = "Clothing"
        static let categoryCount = "102"
        static let placeholderImage = "photo"
    }
    
    //MARK: - Properties
    static let identifier = "CategoriesCell"
    
    // MARK: - UI Элементы
    private let imagesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageViews: [UIImageView] = (0..<Drawings.imageCount).map { _ in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: Drawings.placeholderImage)
        return imageView
    }
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Drawings.stackSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Drawings.categoryTitle
        label.font = Fonts.ralewayBold17
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = Drawings.categoryCount
        label.font = Fonts.ralewayBold12
        label.textColor = .customBlack
        label.textAlignment = .center
        label.backgroundColor = .customBlueForHome
        label.layer.cornerRadius = Drawings.countLabelCornerRadius
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 40).isActive = true
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LayoutSubviews (Грид картинок)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = (contentView.frame.width - Drawings.imageSpacing) / CGFloat(Drawings.gridSize)
        
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
    
    //MARK: - Private funcs
    
    private func setupViews() {
        [imagesContainerView, textStackView].forEach(contentView.addSubview)
        
        imageViews.forEach { imagesContainerView.addSubview($0) }
        
        [titleLabel, countLabel].forEach(textStackView.addArrangedSubview)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            imagesContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imagesContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesContainerView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            
            textStackView.topAnchor.constraint(equalTo: imagesContainerView.bottomAnchor, constant: Drawings.textTopPadding),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            countLabel.widthAnchor.constraint(equalToConstant: Drawings.countLabelWidth),
            countLabel.heightAnchor.constraint(equalToConstant: Drawings.countLabelHeight)
        ])
    }
}

// MARK: - SwiftUI Preview for UIKit View
struct CategoriesCell_Preview: PreviewProvider {
    static var previews: some View {
        CatagoriesCellViewWrapper()
            .previewLayout(.sizeThatFits)
            .padding()
            .frame(width: 165, height: 192)
    }
}

struct CatagoriesCellViewWrapper: UIViewRepresentable {
  
    func makeUIView(context: Context) -> UIView {
        let categoriesView = CategoriesCell()
        return categoriesView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
