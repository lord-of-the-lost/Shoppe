//
//  AddressService.swift
//  Shoppe
//
//  Created by Надежда Капацина on 09.03.2025.
//

import Foundation

protocol AddressServiceProtocol {
    var currentAddress: String { get }
    func showAddressEditing()
}

final class AddressService: AddressServiceProtocol {
    static let shared = AddressService()
    private init() {}
    
    var currentAddress: String = "26, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city"
    
    func showAddressEditing() {
        // В реальном приложении здесь навигация на экран редактирования
        NotificationCenter.default.post(name: .showEditAddressAlert, object: nil)
    }
}
