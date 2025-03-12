//
//  Untitled.swift
//  Shoppe
//
//  Created by Надежда Капацина on 09.03.2025.
//

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
    
    private(set) var cartItems: [CartItem] = []
    
    init(addressService: AddressServiceProtocol) {
        self.addressService = addressService
        loadMockData()
    }
    
    func viewDidLoad() {
        view?.updateAddress(addressService.currentAddress)
        calculateTotal()
    }
    
    func editAddressTapped() {
        addressService.showAddressEditing()
    }
    
    func deleteItem(at index: Int) {
        cartItems.remove(at: index)
        calculateTotal()
        view?.reloadCartItems()
    }
    
    func increaseQuantity(at index: Int) {
        cartItems[index].quantity += 1
        calculateTotal()
        view?.reloadCartItems()
    }
    
    func decreaseQuantity(at index: Int) {
        guard cartItems[index].quantity > 1 else { return }
        cartItems[index].quantity -= 1
        calculateTotal()
        view?.reloadCartItems()
    }
}

private extension CartPresenter {
    func loadMockData() {
        cartItems = [
            CartItem(
                id: "1",
                imageName: "product",
                name: "Lorem ipsum dolor sit amet consectetur.",
                price: 24.99,
                quantity: 1,
                color: "Pink",
                size: "Size M"
            ),
            CartItem(
                id: "2",
                imageName: "product",
                name: "Lorem ipsum dolor sit amet consectetur.",
                price: 24.99,
                quantity: 2,
                color: "Pink",
                size: "Size M"
            )
        ]
    }
    
    func calculateTotal() {
        let total = cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        view?.updateTotalPrice(total.formattedAsPrice())
    }
}
