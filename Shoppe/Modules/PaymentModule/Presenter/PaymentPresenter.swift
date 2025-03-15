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
    func item(at index: Int) -> CartItem
    func didTap(action: PaymentVCInteraction)
    func didTapCell(at index: Int)
    func calculateTotal()
//    func showDetailView(with: Model)
}

// MARK: - Presenter
final class PaymentPresenter {
    private weak var view: PaymentViewProtocol?
    var items: [CartItem] = []
}

// MARK: - Private Methods
private extension PaymentPresenter {}

extension PaymentPresenter: PaymentPresenterProtocol {
    
    func calculateTotal() {
        let total = items.reduce(0) { $0 + $1.price }
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
        }
    }
    
    func didTapCell(at index: Int) {
        guard let article = items[safe: index] else { return }
        print("did tap cell at index: \(index), article: \(article)")
    }
    
    func item(at index: Int) -> CartItem {
        return items[index]
    }
    
    func itemsCount() -> Int {
        items.count
    }
    
    func viewDidLoad() {
        calculateTotal()
    }
    
    func setupView(_ view: PaymentViewProtocol) {
        self.view = view
    }
}
