//
//  PaymentPresenterProtocol.swift
//  Shoppe
//
//  Created by Daniil Murzin on 11.03.2025.
//


import Foundation

protocol PaymentPresenterProtocol: AnyObject {
    func setupView(_ view: PaymentViewProtocol)
    func settingsButtonTapped()
}

// MARK: - Presenter
final class PaymentPresenter: PaymentPresenterProtocol {
    private weak var view: PaymentViewProtocol?
    
    func setupView(_ view: PaymentViewProtocol) {
        self.view = view
    }
    
    func settingsButtonTapped() {
        
    }
}

// MARK: - Private Methods
private extension PaymentPresenter {
  
}