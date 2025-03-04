//
//  ExamplePresenterProtocol.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//


import Foundation

protocol HomePresenterProtocol: AnyObject {
    func setupView(_ view: HomeViewProtocol)
    func settingsButtonTapped()
}

// MARK: - Presenter
final class HomePresenter: HomePresenterProtocol {
    private weak var view: HomeViewProtocol?
    
    func setupView(_ view: HomeViewProtocol) {
        self.view = view
    }
    
    func settingsButtonTapped() {
        
    }
    
}

// MARK: - Private Methods
private extension HomePresenter {
  
}
