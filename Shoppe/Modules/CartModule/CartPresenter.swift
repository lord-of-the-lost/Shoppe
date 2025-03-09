//
//  Untitled.swift
//  Shoppe
//
//  Created by Надежда Капацина on 09.03.2025.
//

protocol CartPresenterProtocol: AnyObject {
    func viewDidLoad()
    func editAddressTapped()
}

final class CartPresenter: CartPresenterProtocol {
    weak var view: CartViewProtocol?
    private let addressService: AddressServiceProtocol
    
    init(addressService: AddressServiceProtocol) {
        self.addressService = addressService
    }
    
    func viewDidLoad() {
        view?.updateAddress(addressService.currentAddress)
    }
    
    func editAddressTapped() {
        addressService.showAddressEditing()
    }
}
