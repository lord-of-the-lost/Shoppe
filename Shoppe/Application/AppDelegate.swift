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
        window?.rootViewController = WishlistFactory.makeModule()
        window?.makeKeyAndVisible()
        
        return true
    }
}
