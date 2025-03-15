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
        justForYou: [JustForYourCellViewModel]
    )
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

enum MainVCInteraction {
    case searchFieldDidChange(String)
    case didTapCell(Int)
    case didTapSeeAll(HomeSection)
    case didTapAddToCart(Int)
}

enum HomeSection {
    case categories
    case popular
    case justForYou
}

final class HomeViewController: UIViewController {
    // MARK: - Properties
    private let presenter: HomePresenterProtocol
    private lazy var dataSource: HomeViewDataSource = HomeViewDataSource(collectionView)
    
    // MARK: - UI Elements
    private lazy var addressView = HeaderAddressView()
    private lazy var shopTitleView = HomeTitleView(title: "Shop")
    private lazy var searchView: SearchView = {
        let searchView = SearchView()
        searchView.delegate = self
        return searchView
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
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func updateUI(
        categories: [CategoryCellViewModel],
        popular: [PopularCellViewModel],
        justForYou: [JustForYourCellViewModel]
    ) {
        errorLabel.isHidden = true
        dataSource.updateSnapshot(
            categories: categories,
            popular: popular,
            justForYou: justForYou
        )
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
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch dataSource.itemAt(indexPath) {
        case .category(let category):
            presenter.didTap(action: .didTapCell(category.id))
            
        case .justForYou(let product):
            presenter.didTap(action: .didTapCell(product.id))
            
        case .popular(let product):
            presenter.didTap(action: .didTapCell(product.id))
            
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

// MARK: - Private Methods
private extension HomeViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubviews(mainStackView, collectionView, loadingIndicator, errorLabel)
        
        shopStackView.addArrangedSubview(shopTitleView)
        shopStackView.addArrangedSubview(searchView)
        
        mainStackView.addArrangedSubview(addressView)
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
    func handleAddToCart(_ id: Int) {
        presenter.didTap(action: .didTapAddToCart(id))
    }
    
    func handleSeeAll(_ section: HomeSection) {
        presenter.didTap(action: .didTapSeeAll(section))
    }
}
