//
//  HomeViewCompLayout.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//

import UIKit

final class HomeViewCompLayout {
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch Section(rawValue: sectionIndex) {
            case .categories:
                let spacing: CGFloat = 8.0
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalWidth(0.6)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: spacing,
                    leading: spacing,
                    bottom: spacing,
                    trailing: spacing
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(0.6)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item, item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: spacing,
                    leading: spacing,
                    bottom: spacing,
                    trailing: spacing
                )
                return section
            case .popular:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(256),
                    heightDimension: .absolute(256)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 12,
                    leading: 8,
                    bottom: 24,
                    trailing: 8
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(272),
                    heightDimension: .absolute(296)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .continuous
                
                return section
                
            case .justForYou:
                let spacing: CGFloat = 8.0
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalWidth(0.6)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: spacing,
                    leading: spacing,
                    bottom: spacing,
                    trailing: spacing
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(0.6)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item, item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: spacing,
                    leading: spacing,
                    bottom: spacing,
                    trailing: spacing
                )
                return section
            default:
                assertionFailure()
                return nil
            }
        }
        return layout
    }
}
