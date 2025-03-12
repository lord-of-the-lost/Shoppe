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
    func settingsButtonTapped()
    func itemsCount() -> Int
    func item(at index: Int) -> ItemCellViewModel
}

// MARK: - Presenter
final class PaymentPresenter  {
    private weak var view: PaymentViewProtocol?
    var items: [ItemCellViewModel] = []
}

// MARK: - Private Methods
private extension PaymentPresenter {}


extension PaymentPresenter: PaymentPresenterProtocol {
    func item(at index: Int) -> ItemCellViewModel {
        return items[index]
    }
    
    func itemsCount() -> Int {
        items.count
    }
    
    func viewDidLoad() {
        items = ItemsMock.all
    }
    
    
    func setupView(_ view: PaymentViewProtocol) {
        self.view = view
    }
    
    func settingsButtonTapped() {
        
    }
}
