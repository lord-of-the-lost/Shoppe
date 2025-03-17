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
}

final class PaymentPresenter {
    private weak var view: PaymentViewProtocol?
    private let router: AppRouterProtocol
    private let basketService: BasketServiceProtocol
    private let userDefaultsService: UserDefaultsService = UserDefaultsService.shared
    
    private var user: User? {
        userDefaultsService.getCustomObject(forKey: .userModel)
    }
    
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
    func setupView(_ view: PaymentViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        updateData()
        view?.updateShippingAddress(user?.address ?? "No address selected")
    }

    func updateData() {
        let total = basketService.items.reduce(0) { $0 + ($1.price * Double($1.count)) }
        let itemCount = basketService.items.count
        view?.updateUI(itemsCount: itemCount, total: total)
        view?.reloadTableView()
    }

    func didTap(action: PaymentVCInteraction) {
        switch action {
        case .addVoucher:
            print("Добавление ваучера")
        case .addressEdit:
            print("Редактирование адреса")
        case .paymentMethodEdit:
            print("Редактирование метода оплаты")
        case .payButton:
            print("Оплата заказа")
        case .itemCell:
            print("Выбран товар")
        case .close:
            router.dismiss(animated: true)
        case .trackMyOrder:
            paymentSuccess()
        }
    }

    func didTapCell(at index: Int) {
        guard let product = basketService.items[safe: index] else { return }
        print("Выбран товар: \(product)")
    }

    func item(at index: Int) -> Product {
        return basketService.items[index]
    }

    func itemsCount() -> Int {
        basketService.items.count
    }
    
    func paymentSuccess() {
        basketService.clearBasket()
        router.dismiss(animated: true)
    }
}
