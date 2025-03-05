//
//  WishlistViewController.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 05.03.2025.
//

import UIKit

final class WishlistViewController: UIViewController {
    //MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Wishlist"
        label.textColor = .customBlack
        label.font = Fonts.ralewayExtraBold.withSize(24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = Fonts.ralewayMedium.withSize(16)
        button.setTitleColor(.lightGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.backgroundColor = .customLightGray
        text.layer.cornerRadius = 18
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: (view.bounds.width - 30) / 2, height: 300)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //            collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.backgroundColor = .customRed
        //            collectionView.dataSource = self
        //            collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.titleView = titleLabel
        setupView()
        setupConstraints()
    }
}
//MARK: - Extensions Constraints
private extension WishlistViewController {
    func setupView() {
        view.backgroundColor = .white
        [
            searchButton,
            textField,
            collectionView
        ].forEach { view.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            searchButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            textField.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            textField.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 20),
            textField.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
        ])
    }
}
//extension WishlistViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    
//    // MARK: UICollectionViewDataSource
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return configs.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
////        let config = configs[indexPath.item]
////        cell.configureCell(image:UIImage(named: config.image), description: config.description, price: config.price)
////        
////        return cell
//    }
// 
//    // MARK: UICollectionViewDelegate
//    
//    
//}
//// MARK: - UICollectionViewDelegateFlowLayout
//extension WishlistViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.bounds.width - 30) / 2 // Ширина экрана минус отступы, деленная на 2
//        let height: CGFloat = 300
//        return CGSize(width: width, height: height)
//    }
//}
