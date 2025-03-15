//
//  HomeViewCompLayout.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//

import UIKit

enum HomeViewCompLayout {
    
    private enum Drawings {
        // Header
        static let headerHeight: CGFloat = 50
        static let headerFractionalWidth: CGFloat = 1
        static let zeroSpacing: CGFloat = 0.0

        // Categories Section
        static let categoriesSpacing: CGFloat = 5.0
        static let categoriesItemWidth: CGFloat = 0.5
        static let categoriesItemHeight: CGFloat = 0.6
        static let categoriesGroupHeight: CGFloat = 0.6
        static let categoriesGroupWidth: CGFloat = 1

        // Popular Section
        static let popularItemWidth: CGFloat = 150
        static let popularItemHeight: CGFloat = 220
        static let popularGroupHeight: CGFloat = 250
        static let popularGroupWidth: CGFloat = 1
        // JustForYou Section
        static let justForYouSpacing: CGFloat = 8.0
        static let justForYouItemWidth: CGFloat = 0.5
        static let justForYouItemHeight: CGFloat = 0.6
        static let justForYouGroupHeight: CGFloat = 0.59
        static let justForYouGroupWidth: CGFloat = 1

        // Strings
        static let headerElementKind = UICollectionView.elementKindSectionHeader
    }

    
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch Section(rawValue: sectionIndex) {
            case .categories:
                let spacing = Drawings.categoriesSpacing
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(Drawings.categoriesItemWidth),
                    heightDimension: .fractionalWidth(Drawings.categoriesItemHeight)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: Drawings.zeroSpacing,
                    leading: spacing,
                    bottom: spacing,
                    trailing: Drawings.zeroSpacing
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(Drawings.categoriesGroupHeight)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item, item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: Drawings.zeroSpacing,
                    leading: spacing,
                    bottom: spacing,
                    trailing: Drawings.zeroSpacing
                )
                section.boundarySupplementaryItems = [createHeader()]
                return section

            case .popular:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(Drawings.popularItemWidth),
                    heightDimension: .estimated(Drawings.popularItemHeight)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(Drawings.popularItemWidth),
                    heightDimension: .absolute(Drawings.popularGroupHeight)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [createHeader()]
                return section
                
            case .justForYou:
                let spacing = Drawings.justForYouSpacing
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(Drawings.justForYouItemWidth),
                    heightDimension: .absolute(290)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: Drawings.zeroSpacing,
                    leading: spacing,
                    bottom: Drawings.zeroSpacing,
                    trailing: spacing
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(Drawings.justForYouGroupWidth),
                    heightDimension: .absolute(310)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item, item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: Drawings.zeroSpacing,
                    leading: spacing,
                    bottom: 10,
                    trailing: spacing
                )
                section.boundarySupplementaryItems = [createHeader()]
                return section

            default:
                assertionFailure()
                return nil
            }
        }
        return layout
    }
    
    private static func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Drawings.headerFractionalWidth),
            heightDimension: .absolute(Drawings.headerHeight)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Drawings.headerElementKind,
            alignment: .topLeading
        )
        
        header.pinToVisibleBounds = false
        header.contentInsets = .zero
        
        return header
    }
}

