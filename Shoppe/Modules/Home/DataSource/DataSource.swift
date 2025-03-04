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
        case category(Category)
        case popular(Popular)
        case justForYou(JustForYou)
    }
    
    //MARK: - Init
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView.dataSource = dataSource
        collectionView.register(
            CategoriesCell.self,
            forCellWithReuseIdentifier: CategoriesCell.identifier
        )
    }
    
    func updateSnapshot(categories: [Category], popular: [Popular], justForYou: [JustForYou]) {
        dataSource.apply(Snapshot(categories: categories), animatingDifferences: true)
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
        case categories, topHeadlines
    }
    
    func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .category(let category):
                nil
            case .popular:
                nil
            case .justForYou:
                nil
            }
            
            }
    }
}
// TODO: sections
private extension HomeViewDataSource.Snapshot {
    init(categories: [Category]) {
        self.init()
        appendSections(HomeViewDataSource.Section.allCases)
        appendItems(categories.map { HomeViewDataSource.Item.category($0) }, toSection: .categories)
    }
}
