//
//  ExampleViewProtocol.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//

import UIKit
import SwiftUI

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

    
    private lazy var header: MainHeaderView = {
        let header = MainHeaderView()
        header.delegate = self
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.3,
            delay: 0.05 * Double(indexPath.row),
            options: [.curveEaseInOut]
        ) {
            cell.alpha = 1
        }
    }
}

// MARK: - MainHeaderViewDelegate
extension HomeViewController: MainHeaderViewDelegate {
    func addressTaped() {
        presenter.addressTapped()
    }
    
    func searchTapped() {
        presenter.searchTapped()
    }
    
    func searchTextChanged(_ text: String) {
        presenter.didTap(action: .searchFieldDidChange(text))
    }
}

// MARK: - Private Methods
private extension HomeViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubviews(collectionView, header, loadingIndicator, errorLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
