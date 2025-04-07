//
//  CategoryProductCell.swift
//  Shoppe
//
//  Created by Николай Игнатов on 17.03.2025.
//

import UIKit

// MARK: - Protocols
protocol CategoryProductCellDelegate: AnyObject {
    func categoryProductCell(_ cell: CategoryProductCell, didSelectProduct product: Product)
}

final class CategoryProductCell: UITableViewCell {
    static let identifier = "CategoryProductCell"
    
    weak var delegate: CategoryProductCellDelegate?
    private var products: [Product] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = false
        collection.register(ProductItemCell.self, forCellWithReuseIdentifier: ProductItemCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with products: [Product]) {
        self.products = products
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryProductCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductItemCell.identifier,
            for: indexPath
        ) as? ProductItemCell else {
            return UICollectionViewCell()
        }
        
        if let product = products[safe: indexPath.item] {
            cell.configure(with: product.title)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryProductCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = products[safe: indexPath.item] {
            delegate?.categoryProductCell(self, didSelectProduct: product)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryProductCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16) / 2
        return CGSize(width: width, height: 44)
    }
}

// MARK: - Private Methods
private extension CategoryProductCell {
    func setupView() {
        contentView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
