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
        label.textColor = .black
        label.font = Fonts.ralewayBold.withSize(28)
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var searchView: SearchView = {
        let searchView = SearchView()
        searchView.delegate = self
        searchView.setSearchState(.placeholder)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        return searchView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
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

// MARK: - WishlistViewProtocol
extension WishlistViewController: WishlistViewProtocol {
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
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
            id: model.id,
            image: model.image,
            title: model.title,
            price: String(format: "$%.2f", model.price),
            isOnCart: model.isInCart,
            isOnWishlist: model.isInWishlist
        )
        
        cell.configure(with: viewModel)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WishlistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didTapProduct(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishlistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.bounds.width - 30) / 2, height: 300)
    }
}

// MARK: - SearchViewDelegate
extension WishlistViewController: SearchViewDelegate {
    func placeholderTapped() {
        presenter.showSearch()
    }
}

// MARK: - ProductCellDelegate
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
        view.addSubviews(titleLabel, searchView, collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            searchView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            searchView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchView.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
