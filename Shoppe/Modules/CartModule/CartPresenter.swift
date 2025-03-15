//
//  Untitled.swift
//  Shoppe
//
//  Created by Надежда Капацина on 09.03.2025.
//
import Foundation

protocol CartPresenterProtocol: AnyObject {
    
    var cartItems: [CartItem] { get }
    
    func viewDidLoad()
    func editAddressTapped()
    func deleteItem(at index: Int)
    func increaseQuantity(at index: Int)
    func decreaseQuantity(at index: Int)
}

final class CartPresenter: CartPresenterProtocol {
    weak var view: CartViewProtocol?
    private let addressService: AddressServiceProtocol
    private let basketService: BasketServiceProtocol
    
    var cartItems: [CartItem] {
        basketService.items
    }
    
    init(addressService: AddressServiceProtocol,
         basketService: BasketServiceProtocol = BasketService.shared) {
        self.addressService = addressService
        self.basketService = basketService
        setupObservers()
    }
    
    func viewDidLoad() {
        view?.updateAddress(addressService.currentAddress)
        calculateTotal()
    }
    
    func editAddressTapped() {
        addressService.showAddressEditing()
    }
    
    func deleteItem(at index: Int) {
        let item = cartItems[index]
        basketService.removeItem(withId: item.id)
        calculateTotal()
    }
    
    func increaseQuantity(at index: Int) {
        let item = cartItems[index]
        basketService.updateQuantity(for: item.id, newQuantity: item.quantity + 1)
        calculateTotal()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBasketUpdate),
            name: .basketDidUpdate,
            object: nil
        )
    }
    func decreaseQuantity(at index: Int) {
        let item = cartItems[index]
        let newQuantity = max(item.quantity - 1, 1)
        basketService.updateQuantity(for: item.id, newQuantity: newQuantity)
        calculateTotal()
    }
}

private extension CartPresenter {

    @objc func handleBasketUpdate() {
        calculateTotal()
        view?.reloadCartItems()
    }
    
    func calculateTotal() {
        let total = basketService.items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        view?.updateTotalPrice(total.formattedAsPrice())
    }
}
