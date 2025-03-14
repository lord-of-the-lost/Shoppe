//
//  SearchViewController.swift
//  Shoppe
//
//  Created by Николай Игнатов on 11.03.2025.
//

import UIKit

enum SearchState {
    case empty
    case history([String])
    case results([ProductCellViewModel])
}

protocol SearchViewProtocol: AnyObject {
    func updateState(_ state: SearchState)
    func updateSearchText(_ text: String)
}

final class SearchViewController: UIViewController {
    private let presenter: SearchPresenterProtocol
    private var currentState: SearchState = .empty
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shop"
        label.textColor = .black
        label.font = Fonts.ralewayBold
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchView: SearchView = {
        let searchView = SearchView()
        searchView.delegate = self
        searchView.setSearchState(.active)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        return searchView
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.backward")
        config.preferredSymbolConfigurationForImage = .init(pointSize: 20, weight: .regular, scale: .default)
        let button = UIButton()
        button.configuration = config
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var clearSearchHistoryButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .trash)
        config.preferredSymbolConfigurationForImage = .init(pointSize: 35, weight: .regular, scale: .default)
        let button = UIButton()
        button.configuration = config
        button.addTarget(self, action: #selector(clearSearchHistoryTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = ChipsCollectionViewLayout()
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collection.register(ChipsCollectionViewCell.self, forCellWithReuseIdentifier: ChipsCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Lifecycle
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        presenter.viewDidLoad()
    }
}

// MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    func updateState(_ state: SearchState) {
        currentState = state
        
        switch state {
        case .empty:
            stateLabel.text = "Search history is Empty"
            stateLabel.isHidden = false
            searchView.setSearchState(.active)
            clearSearchHistoryButton.isHidden = true
            collectionView.isHidden = true
        case .history(let items):
            stateLabel.text = "Search history"
            stateLabel.isHidden = false
            clearSearchHistoryButton.isHidden = items.isEmpty
            collectionView.isHidden = items.isEmpty
            collectionView.reloadData()
        case .results:
            stateLabel.isHidden = true
            clearSearchHistoryButton.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
    
    func updateSearchText(_ text: String) {
        searchView.setSearchState(.searchResult(text))
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentState {
        case .empty: 0
        case .history(let items): items.count
        case .results(let items): items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch currentState {
        case .history(let items):
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipsCollectionViewCell.identifier, for: indexPath) as? ChipsCollectionViewCell,
                  let model = items[safe: indexPath.item] else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: model)
            cell.delegate = self
            return cell
            
        case .results(let items):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell,
                  let model = items[safe: indexPath.item] else {
                return UICollectionViewCell()
            }
            cell.configure(with: model)
            cell.delegate = self
            return cell
            
        case .empty:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch currentState {
        case .history(let items):
            guard let text = items[safe: indexPath.item] else { return .zero }
            let font = Fonts.ralewayRegular.withSize(14)
            let textWidth = (text as NSString).size(withAttributes: [.font: font]).width
            let maxWidth = collectionView.bounds.width
            let width = min(textWidth + 44, maxWidth)
            return CGSize(width: width, height: 28)
            
        case .results:
            return CGSize(width: (collectionView.bounds.width / 2) - 4, height: 280)
            
        case .empty:
            return .zero
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case .history(let items) = currentState,
           let selectedText = items[safe: indexPath.item] {
            presenter.searchButtonClicked(with: selectedText)
        }
    }
}

// MARK: - SearchViewDelegate
extension SearchViewController: SearchViewDelegate {
    func clearSearchTapped() {
        presenter.clearSearchTapped()
    }
    
    func showProducts(_ query: String) {
        presenter.searchButtonClicked(with: query)
    }
}

// MARK: - ProductCellDelegate
extension SearchViewController: ProductCellDelegate {
    func addToCartTapped(_ cell: ProductCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        presenter.addToCartTapped(at: index)
    }
    
    func likeTapped(_ cell: ProductCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        presenter.likeTapped(at: index)
    }
}

// MARK: - ChipsCollectionViewCellDelegate
extension SearchViewController: ChipsCollectionViewCellDelegate {
    func deleteButtonTapped(in cell: ChipsCollectionViewCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        presenter.removeHistoryItem(at: index)
    }
}

// MARK: - Private Methods
private extension SearchViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubviews(
            titleLabel,
            backButton,
            searchView,
            stateLabel,
            clearSearchHistoryButton,
            collectionView
        )
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            backButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            
            searchView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchView.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            
            stateLabel.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 11),
            stateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            clearSearchHistoryButton.centerYAnchor.constraint(equalTo: stateLabel.centerYAnchor),
            clearSearchHistoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            clearSearchHistoryButton.widthAnchor.constraint(equalToConstant: 35),
            clearSearchHistoryButton.heightAnchor.constraint(equalToConstant: 35),
            
            collectionView.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func clearSearchHistoryTapped() {
        presenter.clearSearchHistoryTapped()
    }
    
    @objc func backButtonTapped() {
        presenter.backButtonTapped()
    }
}
