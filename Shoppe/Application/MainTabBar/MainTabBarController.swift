//
//  MainTabBarController.swift
//  Shoppe
//
//  Created by Надежда Капацина on 04.03.2025.
//

import UIKit

struct TabItemConfig {
    let viewController: UIViewController
    let iconName: String
}

final class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    private let selectionIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tabItems: [TabItemConfig] = [
        TabItemConfig(viewController: UIViewController(), iconName: "Home"),
        TabItemConfig(viewController: UIViewController(), iconName: "Heart"),
        TabItemConfig(viewController: UIViewController(), iconName: "Categories"),
        TabItemConfig(viewController: UIViewController(), iconName: "Bag"),
        TabItemConfig(viewController: UIViewController(), iconName: "Person")
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
        setupSelectionIndicator()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if selectionIndicator.frame.origin.x == 0 {
            setInitialSelection()
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateIndicatorPosition(animated: true)
        }
    }
    
    // MARK: - Setup
    private func setupViewControllers() {
        viewControllers = tabItems.map { config in
            let navController = UINavigationController(rootViewController: config.viewController)
            navController.tabBarItem = UITabBarItem(
                title: nil,
                image: UIImage(named: config.iconName)?.withRenderingMode(.alwaysTemplate),
                selectedImage: nil
            )
            return navController
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.stackedLayoutAppearance.normal.iconColor = .customBlue
        appearance.stackedLayoutAppearance.selected.iconColor = .customBlack
        
   
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupSelectionIndicator() {
        tabBar.addSubview(selectionIndicator)
        NSLayoutConstraint.activate([
            selectionIndicator.widthAnchor.constraint(equalToConstant: 12),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 4),
            selectionIndicator.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Positioning
    private func setInitialSelection() {
        guard tabBar.subviews.count > 0 else { return }
        
        selectedIndex = 0
        tabBar.layoutIfNeeded()
        updateIndicatorPosition(animated: false)
    }
    
    private func updateIndicatorPosition(animated: Bool) {
        guard let items = tabBar.items,
              selectedIndex < items.count,
              let itemView = items[selectedIndex].value(forKey: "view") as? UIView else { return }
        
        let tabBarFrame = tabBar.convert(itemView.frame, from: itemView.superview)
        let xPosition = tabBarFrame.midX - 6
        
        guard xPosition != selectionIndicator.frame.origin.x else { return }
        
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut) {
                self.selectionIndicator.frame.origin.x = xPosition
            }
        } else {
            selectionIndicator.frame.origin.x = xPosition
        }
    }
}
