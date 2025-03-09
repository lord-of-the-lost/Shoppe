//
//  AppDelegate.swift
//  Shoppe
//
//  Created by Николай Игнатов on 03.03.2025.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarFactory.makeModule()
        window?.makeKeyAndVisible()
        configureAddressEditingObserver()
        return true
    }

    private func configureAddressEditingObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showAddressEditingAlert),
            name: .showEditAddressAlert,
            object: nil
        )
    }

    @objc private func showAddressEditingAlert() {
        let alert = UIAlertController(
            title: "Раздел в разработке",
            message: "Редактирование адреса будет доступно в следующей версии",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        window?.rootViewController?.present(alert, animated: true)
    }

}
