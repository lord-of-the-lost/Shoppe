//
//  Untitled.swift
//  Shoppe
//
//  Created by Надежда Капацина on 09.03.2025.
//

import UIKit

protocol CartPresenterProtocol: AnyObject {
    var cartItems: [CartItem] { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func deleteItem(at index: Int)
    func increaseQuantity(at index: Int)
    func decreaseQuantity(at index: Int)
    func showPaymentView()
}

final class CartPresenter: CartPresenterProtocol {
    // MARK: - Properties
    weak var view: CartViewProtocol?
    private let router: AppRouterProtocol
    private let basketService: BasketServiceProtocol
    private(set) var cartItems: [CartItem] = []
    
    private var currentCurrency: Currency {
        guard let user: User = UserDefaultsService.shared.getCustomObject(forKey: .userModel) else {
            return .dollar
        }
        return user.currentCurrency
    }
    
    private var currentAddress: String {
        guard let user: User = UserDefaultsService.shared.getCustomObject(forKey: .userModel) else {
            return "Калифорния"
        }
        return user.address
    }
    
    // MARK: - Initialization
    init(
        router: AppRouterProtocol,
        basketService: BasketServiceProtocol = BasketService.shared
    ) {
        self.router = router
        self.basketService = basketService
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Protocol Methods
extension CartPresenter {
    func viewDidLoad() {
        updateCartItems()
        view?.updateAddress(currentAddress)
        calculateTotal()
    }
    
    func viewWillAppear() {
        updateCartItems()
        view?.updateAddress(currentAddress)
        calculateTotal()
    }
    
    func deleteItem(at index: Int) {
        guard let product = basketService.items[safe: index] else { return }
        basketService.removeItem(product)
        updateCartItems()
    }
    
    func increaseQuantity(at index: Int) {
        guard let product = basketService.items[safe: index] else { return }
        basketService.updateQuantity(for: product.id, newQuantity: product.count + 1)
        updateCartItems()
    }
    
    func decreaseQuantity(at index: Int) {
        guard
            let product = basketService.items[safe: index],
            product.count > 1
        else { return }
        
        basketService.updateQuantity(for: product.id, newQuantity: product.count - 1)
        updateCartItems()
    }
    
    func showPaymentView() {
        router.showPaymentView()
    }
}

// MARK: - Private Methods
private extension CartPresenter {
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBasketUpdate),
            name: .basketDidUpdate,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLocationUpdate),
            name: .locationAndCurrencyDidUpdate,
            object: nil
        )
    }
    
    @objc func handleLocationUpdate() {
        view?.updateAddress(currentAddress)
        calculateTotal()
    }
    
    @objc func handleBasketUpdate() {
        updateCartItems()
    }
    
    private func updateCartItems() {
        cartItems = basketService.items.map { product in
            CartItem(
                image: product.image ?? UIImage(),
                name: product.title,
                category: product.category.displayName,
                price: product.price,
                quantity: product.count
            )
        }
        calculateTotal()
        view?.reloadCartItems()
    }
    
    private func calculateTotal() {
        let total = cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        view?.updateTotalPrice(total.formattedAsPrice(currency: currentCurrency))
    }
}
