//
//  Untitled.swift
//  Shoppe
//
//  Created by Надежда Капацина on 09.03.2025.
//
import UIKit
enum CartFactory {
    static func makeModule() -> UIViewController {
        let addressService = AddressService.shared
        let presenter = CartPresenter(addressService: addressService)
        let viewController = CartViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
