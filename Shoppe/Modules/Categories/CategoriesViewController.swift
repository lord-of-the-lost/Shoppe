//
//  CategoriesPresenter.swift
//  Shoppe
//
//  Created by Николай Игнатов on 16.03.2025.
//

import UIKit

// MARK: - Models
struct Category {
    let id: Int
    let title: String
    let items: [Product]
    var isExpanded: Bool
    
    var image: UIImage? {
        items.first?.image
    }
}

// MARK: - Protocols
protocol CategoriesViewProtocol: AnyObject {
    func updateCategories(_ categories: [Category])
}

final class CategoriesViewController: UIViewController {
    private let presenter: CategoriesPresenterProtocol
    private var categories: [Category] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemGray6
        collection.delegate = self
        collection.dataSource = self
        collection.register(CategoryHeaderCell.self, forCellWithReuseIdentifier: CategoryHeaderCell.identifier)
        collection.register(CategoryProductCell.self, forCellWithReuseIdentifier: CategoryProductCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    init(presenter: CategoriesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
    }
    
    private func setupView() {
        view.backgroundColor = .systemGray6
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let category = self.categories[sectionIndex]
            
            // Header item
            let headerItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(60)
                )
            )
            
            let headerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(60)
                ),
                subitems: [headerItem]
            )
            
            // Products
            let productItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .absolute(44)
                )
            )
            
            let productGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(44)
                ),
                subitem: productItem,
                count: 2
            )
            productGroup.interItemSpacing = .fixed(8)
            
            // Section
            let section = NSCollectionLayoutSection(group: headerGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
            
            if category.isExpanded {
                let productsGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(44)
                    ),
                    subitems: [productGroup]
                )
                productsGroup.interItemSpacing = .fixed(8)
                
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .estimated(44)
                        ),
                        elementKind: UICollectionView.elementKindSectionFooter,
                        alignment: .bottom
                    )
                ]
            }
            
            return section
        }
        
        return layout
    }
}

// MARK: - UICollectionViewDataSource
extension CategoriesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let category = categories[safe: section] else { return 0 }
        return category.isExpanded ? category.items.count + 1 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let category = categories[safe: indexPath.section] else {
            return UICollectionViewCell()
        }
        
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryHeaderCell.identifier,
                for: indexPath
            ) as? CategoryHeaderCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: category)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryProductCell.identifier,
                for: indexPath
            ) as? CategoryProductCell,
                  let product = category.items[safe: indexPath.item - 1] else {
                return UICollectionViewCell()
            }
            cell.configure(with: product.title)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let category = categories[safe: indexPath.section] else { return }
        
        if indexPath.item == 0 {
            presenter.toggleCategory(at: indexPath.section)
        } else {
            guard let product = category.items[safe: indexPath.item - 1] else { return }
            presenter.didSelectProduct(product)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.bounds.width - 32, height: 60)
        } else {
            let width = (collectionView.bounds.width - 48) / 2
            return CGSize(width: width, height: 44)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}

// MARK: - CategoriesViewProtocol
extension CategoriesViewController: CategoriesViewProtocol {
    func updateCategories(_ categories: [Category]) {
        self.categories = categories
        collectionView.reloadData()
    }
}
