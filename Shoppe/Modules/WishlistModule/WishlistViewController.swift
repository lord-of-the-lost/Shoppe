//
//  WishlistViewController.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 05.03.2025.
//

import UIKit

protocol WishlistViewProtocol: AnyObject {
    func reloadData()
}

final class WishlistViewController: UIViewController {
    //MARK: - Properties
    private let presenter: WishlistPresenterProtocol
    
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
        layout.itemSize = CGSize(width: (view.bounds.width - 30) / 2, height: 300)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
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
    
    init(presenter: WishlistPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: WishlistViewProtocol
extension WishlistViewController: WishlistViewProtocol {
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension WishlistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getProductsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell,
            let model = presenter.getProduct(at: indexPath.item)
        else {
            assertionFailure()
            return UICollectionViewCell()
        }
        let viewModel = ProductCellViewModel(
            image: model.image,
            description: model.description,
            price: String(format: "$%.2f", model.price),
            isOnCart: model.isInCart,
            isOnWishlist: model.isInWishlist
        )
        
        cell.configure(with: viewModel)
        cell.onLikeTapped = { [weak self] in
            self?.presenter.toggleProductLike(at: indexPath.item)
        }
        cell.onAddToCartTapped = { [weak self] in
            self?.presenter.addToCartProduct(at: indexPath.item)
        }
        cell.delegate = self
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension WishlistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didTapProduct(at: indexPath.item)
    }
}

// MARK: ProductCellDelegate
// TODO: Сейчас не работает, переделать через замыкания
extension WishlistViewController: ProductCellDelegate {
    func addToCartTapped(_ cell: ProductCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        presenter.addToCartProduct(at: index)
    }
    
    func likeTapped(_ cell: ProductCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        presenter.toggleProductLike(at: index)
    }
}

//MARK: - Private Methods
private extension WishlistViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(searchButton)
        view.addSubview(textField)
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            searchButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            textField.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            textField.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 20),
            textField.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        ])
    }
}
