//
//  ExampleViewProtocol.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//

import UIKit

// MARK: - Protocols
protocol HomeViewProtocol: AnyObject {
    func updateUI(
        categories: [CategoryCellViewModel],
        popular: [PopularCellViewModel],
        justForYou: [ProductCellViewModel]
    )
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func updateCartBadge(count: Int)
    func updateAddress(_ address: String)
}

enum MainVCInteraction {
    case didTapCategory(Int)
    case didTapPopularProduct(Int)
    case didTapJustForYouProduct(Int)
    case didTapSeeAll(HomeSection)
}

enum HomeSection {
    case categories
    case popular
    case justForYou
}

final class HomeViewController: UIViewController {
    // MARK: - Properties
    private let presenter: HomePresenterProtocol
    private lazy var dataSource = HomeViewDataSource(collectionView, headerViewModels: makeHeaderViewModels())
    
    // MARK: - UI Elements
    private lazy var shopTitleView = HomeTitleView(title: "Shop")
    private lazy var searchView: SearchView = {
        let searchView = SearchView()
        searchView.delegate = self
        return searchView
    }()
    
    private lazy var headerAddressView: HeaderAddressView = {
        let headerAddressView = HeaderAddressView()
        headerAddressView.delegate = self
        return headerAddressView
    }()
    
    private lazy var shopStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: HomeViewCompLayout.createLayout()
        )
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.delegate = self
        return collection
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        presenter.setupView(self)
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func updateUI(
        categories: [CategoryCellViewModel],
        popular: [PopularCellViewModel],
        justForYou: [ProductCellViewModel]
    ) {
        errorLabel.isHidden = true
        dataSource.updateSnapshot(
            categories: categories,
            popular: popular,
            justForYou: justForYou
        )
    }
    
    func updateCartBadge(count: Int) {
        headerAddressView.updateBadge(count: count)
    }
    
    func updateAddress(_ address: String) {
        headerAddressView.updateAddress(address)
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
        collectionView.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        collectionView.isUserInteractionEnabled = true
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch dataSource.itemAt(indexPath) {
        case .category(let category):
            presenter.didTap(action: .didTapCategory(category.id))
            
        case .popular(let product):
            presenter.didTap(action: .didTapPopularProduct(product.id))
            
        case .justForYou(let product):
            presenter.didTap(action: .didTapJustForYouProduct(product.id))
            
        case .none:
            assertionFailure("Invalid IndexPath")
        }
    }
}


// MARK: - SearchViewDelegate
extension HomeViewController: SearchViewDelegate {
    func placeholderTapped() {
        presenter.searchTapped()
    }
}

// MARK: - HeaderAddressViewDelegate
extension HomeViewController: HeaderAddressViewDelegate {
    func addressTapped() {
        presenter.addressTapped()
    }
    
    func cartTapped() {
        presenter.cartTapped()
    }
}


// MARK: - Private Methods
private extension HomeViewController {
    func makeHeaderViewModels() -> [HomeViewDataSource.Section: HeaderViewModel] {
        return [
            .categories: HeaderViewModel(title: "Categories", action: { [weak self] in self?.handleSeeAll(.categories) }, isHidden: false),
            .popular: HeaderViewModel(title: "Popular", action: { [weak self] in self?.handleSeeAll(.popular) }, isHidden: false),
            .justForYou: HeaderViewModel(title: "Just For You", action: { [weak self] in self?.handleSeeAll(.justForYou) }, isHidden: false)
        ]
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubviews(mainStackView, collectionView, loadingIndicator, errorLabel)
        
        shopStackView.addArrangedSubview(shopTitleView)
        shopStackView.addArrangedSubview(searchView)
        
        mainStackView.addArrangedSubview(headerAddressView)
        mainStackView.addArrangedSubview(shopStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Cell Action Handlers
extension HomeViewController {
    func handleSeeAll(_ section: HomeSection) {
        presenter.didTap(action: .didTapSeeAll(section))
    }
}

// MARK: - ProductCellDelegate
extension HomeViewController: ProductCellDelegate {
    func addToCartTapped(_ cell: ProductCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        presenter.addToCartTapped(at: index)
    }
    
    func likeTapped(_ cell: ProductCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        presenter.likeTapped(at: index)
    }
}
