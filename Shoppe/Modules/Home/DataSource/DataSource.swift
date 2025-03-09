//
//  DataSource.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//


import UIKit

final class HomeViewDataSource {
    
    // MARK: - Properties
    private let collectionView: UICollectionView
    private lazy var dataSource: DataSource = makeDataSource()
    
    enum Item: Hashable {
        case category(CategoryCellViewModel)
        case popular(PopularCellViewModel)
        case justForYou(JustForYourCellViewModel)
    }
    
    // MARK: - Init
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        registerElements()
        self.dataSource = makeDataSource()
        collectionView.dataSource = dataSource
    }
    
    func updateSnapshot(
        categories: [CategoryCellViewModel],
        popular: [PopularCellViewModel],
        justForYou: [JustForYourCellViewModel]
    ) {

        dataSource.supplementaryViewProvider = makeHeader()
        var snapshot = Snapshot()
        snapshot.appendSections([.categories, .popular, .justForYou])
        snapshot.appendItems(categories.map(Item.category), toSection: .categories)
        snapshot.appendItems(popular.map(Item.popular), toSection: .popular)
        snapshot.appendItems(justForYou.map(Item.justForYou), toSection: .justForYou)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func itemAt(_ indexPath: IndexPath) -> Item? {
        dataSource.itemIdentifier(for: indexPath)
    }
}

// MARK: - Private part
private extension HomeViewDataSource {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, Hashable, CaseIterable {
        case categories = 0, popular, justForYou
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
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
//        dataSource.supplementaryViewProvider = makeHeader()
        
        return dataSource
    }
    

    func makeHeader() -> DataSource.SupplementaryViewProvider {
        return { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.identifier,
                for: indexPath
            ) as? SectionHeader else {
                return nil
            }
            
            let headerModel: HeaderViewModel
            switch Section(rawValue: indexPath.section) {
            case .categories:
                headerModel = HeaderViewModel(
                    title: "Categories",
                    action: { print("See All tapped") },
                    isHidden: false
                )
                
            case .popular:
                headerModel = HeaderViewModel(
                    title: "Popular",
                    action: { print("See All tapped") },
                    isHidden: false
                )
                
            case .justForYou:
                headerModel = HeaderViewModel(
                    title: "Just For You",
                    action: { print("See All tapped") },
                    isHidden: false
                )
                
            default:
                return nil
            }
            
            header.configure(headerModel)
            return header
        }
    }
    
    func registerElements() {
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
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.identifier
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
