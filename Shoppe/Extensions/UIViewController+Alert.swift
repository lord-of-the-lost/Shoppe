//
//  UIViewController+Alert.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/9/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
