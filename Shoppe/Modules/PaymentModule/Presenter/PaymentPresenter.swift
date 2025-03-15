//
//  PaymentPresenterProtocol.swift
//  Shoppe
//
//  Created by Daniil Murzin on 11.03.2025.
//

import Foundation

protocol PaymentPresenterProtocol: AnyObject {
    func setupView(_ view: PaymentViewProtocol)
    func viewDidLoad()
    func itemsCount() -> Int
    func item(at index: Int) -> Product
    func didTap(action: PaymentVCInteraction)
    func didTapCell(at index: Int)
    func calculateTotal()
}

// MARK: - Presenter
final class PaymentPresenter {
    private weak var view: PaymentViewProtocol?
    private let router: AppRouterProtocol
    private let basketService: BasketServiceProtocol
    
    init(
        router: AppRouterProtocol,
        basketService: BasketServiceProtocol = BasketService.shared
    ) {
        self.router = router
        self.basketService = basketService
    }
}

// MARK: - PaymentPresenterProtocol
extension PaymentPresenter: PaymentPresenterProtocol {
    func calculateTotal() {
        let total = basketService.items.reduce(0) { $0 + ($1.price * Double($1.count)) }
        view?.updateTotal(total)
    }
    
    func didTap(action: PaymentVCInteraction) {
        switch action {
        case .addVoucher:
            print("addd presenter")
        case .addressEdit:
            break
        case .paymentMethodEdit:
            break
        case .payButton:
            break
        case .itemCell:
            break
        case .close:
            router.dismiss(animated: true)
        case .trackMyOrder:
            router.dismiss(animated: true)
        }
    }
    
    func didTapCell(at index: Int) {
        guard let product = basketService.items[safe: index] else { return }
        print("did tap cell at index: \(index), product: \(product)")
    }
    
    func item(at index: Int) -> Product {
        return basketService.items[index]
    }
    
    func itemsCount() -> Int {
        basketService.items.count
    }
    
    func viewDidLoad() {
        calculateTotal()
    }
    
    func setupView(_ view: PaymentViewProtocol) {
        self.view = view
    }
}
