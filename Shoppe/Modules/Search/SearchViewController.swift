//
//  SearchViewController.swift
//  Shoppe
//
//  Created by Николай Игнатов on 11.03.2025.
//

import UIKit

// MARK: - Models
enum SearchState {
    case empty
    case history([String])
    case results([ProductCellViewModel])
}

// MARK: - View Protocol
protocol SearchViewProtocol: AnyObject {
    func updateState(_ state: SearchState)
    func updateSearchText(_ text: String?)
}

// MARK: - Presenter Protocol
protocol SearchPresenterProtocol: AnyObject {
    func viewDidLoad()
    func searchButtonClicked(with text: String)
    func clearSearchTapped()
    func addToCartTapped(at index: Int)
    func likeTapped(at index: Int)
}

final class SearchViewController: UIViewController {
    // MARK: - Properties
    private var presenter: SearchPresenterProtocol?
    private var currentState: SearchState = .empty
    
    // MARK: - UI Elements
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.backgroundColor = .customGray
        textField.layer.cornerRadius = 8
        textField.delegate = self
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.returnKeyType = .search
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shop"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.text = "Search history is Empty"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collection.register(ChipsCollectionViewCell.self, forCellWithReuseIdentifier: ChipsCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        presenter?.viewDidLoad()
    }
    
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    func updateState(_ state: SearchState) {
    }
    
    func updateSearchText(_ text: String?) {
        
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            presenter?.searchButtonClicked(with: text)
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
                let model = items[safe: indexPath.item]
            else {
                return UICollectionViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .results(let items):
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell,
                let model = items[safe: indexPath.item]
            else {
                return UICollectionViewCell()
            }
            
            cell.delegate = self
            cell.configure(with: model)
            return cell
            
        case .empty:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch currentState {
        case .history:
            return CGSize(width: 100, height: 30) // Размер для chips
        case .results:
            let width = (collectionView.bounds.width - 16) / 2
            return CGSize(width: width, height: width * 1.5) // Размер для продуктов
        case .empty:
            return .zero
        }
    }
}

// MARK: - ProductCellDelegate
extension SearchViewController: ProductCellDelegate {
    func addToCartTapped(_ cell: ProductCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        presenter?.addToCartTapped(at: index)
    }
    
    func likeTapped(_ cell: ProductCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        presenter?.likeTapped(at: index)
    }
}

// MARK: - Private Methods
private extension SearchViewController {
    @objc func clearSearchTapped() {
        searchTextField.text = nil
        presenter?.clearSearchTapped()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(searchTextField)
        view.addSubview(stateLabel)
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            stateLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 32),
            stateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
