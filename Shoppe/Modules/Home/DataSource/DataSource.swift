//
//  DataSource.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//


import UIKit

final class HomeViewDataSource {
    
    //MARK: - Properties
    private let collectionView: UICollectionView
    private lazy var dataSource: DataSource = makeDataSource()
    
    enum Item: Hashable {
        case category(CategoryCellViewModel)
        case popular(PopularCellViewModel)
        case justForYou(JustForYourCellViewModel)
    }
    
    //MARK: - Init
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView.dataSource = dataSource
        registerCells()
    }
    
    func updateSnapshot(
        categories: [CategoryCellViewModel],
        popular: [PopularCellViewModel],
        justForYou: [JustForYourCellViewModel]
    ) {
        dataSource.apply(
            Snapshot(
                categories: categories,
                popular: popular,
                justForYou: justForYou
            ), animatingDifferences: true
        )
    }
    
    func itemAt(_ indexPath: IndexPath) -> Item? {
        dataSource.itemIdentifier(for: indexPath)
    }
}

//MARK: - Private part
private extension HomeViewDataSource {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case categories, popular, justForYou
    }
    // TODO: force unwrap
    func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .category(let category):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoriesCell.identifier,
                    for: indexPath
                ) as! CategoriesCell
                
                cell.configure(with: category)
                return cell
                
            case .popular(let popular):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PopularCell.identifier,
                    for: indexPath
                ) as! PopularCell
                cell.configure(with: popular)
                return cell
                
            case .justForYou(let justForYou):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: JustForYouCell.identifier,
                    for: indexPath
                ) as! JustForYouCell
                cell.configure(with: justForYou)
                return cell
            }
        }
    }
    
    func registerCells() {
        collectionView.register(
            CategoriesCell.self,
            forCellWithReuseIdentifier: CategoriesCell.identifier
        )
        collectionView.register(
            PopularCell.self,
            forCellWithReuseIdentifier: PopularCell.identifier
        )
        collectionView.register(
            JustForYouCell.self,
            forCellWithReuseIdentifier: JustForYouCell.identifier
        )
    }
}

private extension HomeViewDataSource.Snapshot {
    init(
        categories: [CategoryCellViewModel],
        popular: [PopularCellViewModel],
        justForYou: [JustForYourCellViewModel]) {
            self.init()
            
            appendSections(HomeViewDataSource.Section.allCases)
            appendItems(categories.map { HomeViewDataSource.Item.category($0) }, toSection: .categories)
            appendItems(popular.map { HomeViewDataSource.Item.popular($0) }, toSection: .popular)
            appendItems(justForYou.map { HomeViewDataSource.Item.justForYou($0) }, toSection: .justForYou)
        }
}
