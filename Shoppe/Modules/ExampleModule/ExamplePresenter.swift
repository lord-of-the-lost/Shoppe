//
//  ExamplePresenter.swift
//  Shoppe
//
//  Created by Николай Игнатов on 03.03.2025.
//


import Foundation

protocol ExamplePresenterProtocol: AnyObject {
    func setupView(_ view: ExampleViewProtocol)
    func settingsButtonTapped()
}

// MARK: - Presenter
final class ExamplePresenter: ExamplePresenterProtocol {
    private weak var view: ExampleViewProtocol?
    
    func setupView(_ view: ExampleViewProtocol) {
        self.view = view
    }
    
    func settingsButtonTapped() {
        
    }
    
}

// MARK: - Private Methods
private extension ExamplePresenter {
  
}
