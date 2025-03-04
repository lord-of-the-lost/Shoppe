//
//  TabBarAppearance.swift
//  Shoppe
//
//  Created by Надежда Капацина on 04.03.2025.
//

import UIKit

struct TabBarAppearance {
    static func configure(for tabBar: UITabBar) {
        let appearance = UITabBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        appearance.stackedLayoutAppearance.normal.iconColor = .customBlue
        appearance.stackedLayoutAppearance.selected.iconColor = .customBlack
        
         tabBar.scrollEdgeAppearance = appearance
        }
    }


