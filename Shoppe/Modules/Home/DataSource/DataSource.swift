//
//  DataSource.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//


import UIKit

final class HomeViewDataSource {
    
    // MARK: - Enums
    enum Item: Hashable {
        case category(CategoryCellViewModel)
        case popular(PopularCellViewModel)
        case justForYou(ProductCellViewModel)
    }
    
    enum Section: Int, Hashable, CaseIterable {
        case categories, popular, justForYou
    }
    
    enum Header: Hashable {
        case categories(HeaderViewModel)
        case popular(HeaderViewModel)
        case justForYou(HeaderViewModel)

        var model: HeaderViewModel {
            switch self {
            case .categories(let model),
                 .popular(let model),
                 .justForYou(let model):
                return model
            }
        }
    }
    
    // MARK: - Properties
    private let collectionView: UICollectionView
    private lazy var dataSource: DataSource = makeDataSource()
    private let headerModels: [Section: Header]

    // MARK: - Init
    init(_ collectionView: UICollectionView, headerViewModels: [Section: HeaderViewModel]) {
        self.collectionView = collectionView
        self.headerModels = [
            .categories: .categories(headerViewModels[.categories] ?? HeaderViewModel(title: "Categories", action: {}, isHidden: false)),
            .popular: .popular(headerViewModels[.popular] ?? HeaderViewModel(title: "Popular", action: {}, isHidden: false)),
            .justForYou: .justForYou(headerViewModels[.justForYou] ?? HeaderViewModel(title: "Just For You", action: {}, isHidden: false))
        ]
        self.collectionView.dataSource = dataSource
        registerElements()
    }
    
    // MARK: - Update Snapshot
    func updateSnapshot(
        categories: [CategoryCellViewModel],
        popular: [PopularCellViewModel],
        justForYou: [ProductCellViewModel]
    ) {
        dataSource.supplementaryViewProvider = makeHeader()
        dataSource.apply(Snapshot(categories: categories, popular: popular, justForYou: justForYou), animatingDifferences: false)
    }
    
    func itemAt(_ indexPath: IndexPath) -> Item? {
        dataSource.itemIdentifier(for: indexPath)
    }

    func headerAt(_ section: Int) -> Header? {
        guard let sectionEnum = Section(rawValue: section) else { return nil }
        return headerModels[sectionEnum]
    }
}

// MARK: - Private Extension
private extension HomeViewDataSource {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    
    func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .category(let category):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoriesCell.identifier,
                    for: indexPath
                ) as? CategoriesCell else { return nil }
                cell.configure(with: category)
                return cell
                
            case .popular(let popular):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PopularCell.identifier,
                    for: indexPath
                ) as? PopularCell else { return nil }
                cell.configure(with: popular)
                return cell
                
            case .justForYou(let justForYou):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductCell.identifier,
                    for: indexPath
                ) as? ProductCell else { return nil }
                cell.configure(with: justForYou)
                cell.delegate = collectionView.delegate as? ProductCellDelegate
                return cell
            }
        }
    }
    
    func makeHeader() -> DataSource.SupplementaryViewProvider {
        return { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = self.headerAt(indexPath.section) else { return nil }

            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.identifier,
                for: indexPath
            ) as? SectionHeader
            
            headerView?.configure(header.model)
            return headerView
        }
    }
    
    func registerElements() {
        collectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: CategoriesCell.identifier)
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: PopularCell.identifier)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
    }
}

// MARK: - Snapshot Custom Init
private extension HomeViewDataSource.Snapshot {
    init(categories: [CategoryCellViewModel], popular: [PopularCellViewModel], justForYou: [ProductCellViewModel]) {
        self.init()
        appendSections(HomeViewDataSource.Section.allCases)
        appendItems(categories.map { HomeViewDataSource.Item.category($0) }, toSection: .categories)
        appendItems(popular.map { HomeViewDataSource.Item.popular($0) }, toSection: .popular)
        appendItems(justForYou.map { HomeViewDataSource.Item.justForYou($0) }, toSection: .justForYou)
    }
}

