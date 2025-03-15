//
//  CategoryButtonsCell.swift
//  Shoppe
//
//  Created by Вячеслав on 11.03.2025.
//

import Foundation

import UIKit

class CategoryButtonsCell: UITableViewCell {
    
    static let identifier = "CategoryButtonsCell"

    var subcategories: [String] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let cellWidth = (UIScreen.main.bounds.width - 48) / 2  // Две кнопки в ряд
        layout.itemSize = CGSize(width: 400, height: 40)
        layout.estimatedItemSize = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UIButtonCell.self, forCellWithReuseIdentifier: UIButtonCell.identifier)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with subcategories: [String]) {
        self.subcategories = subcategories
        collectionView.reloadData()
    }
}

extension CategoryButtonsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subcategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIButtonCell.identifier, for: indexPath) as? UIButtonCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: subcategories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = subcategories[indexPath.item]
//        let width = (text as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width + 32
        return CGSize(width: (UIScreen.main.bounds.width - 48) / 2, height: 40)
    }
}
