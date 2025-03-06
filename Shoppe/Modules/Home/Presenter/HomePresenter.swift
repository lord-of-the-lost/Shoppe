//
//  ExamplePresenterProtocol.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//


import Foundation

protocol HomePresenterProtocol: AnyObject {
    func setupView(_ view: HomeViewProtocol)
    func viewDidLoad()
}

// MARK: - Presenter
final class HomePresenter: HomePresenterProtocol {
    
    private var categories: [CategoryCellViewModel] = Categories.all
    private var popular: [PopularCellViewModel] = PopularMock.all
    private var justForYou: [JustForYourCellViewModel] = JustForYouMock.all
    private weak var view: HomeViewProtocol?
    
    func setupView(_ view: HomeViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.updateUI(
            categories: categories,
            popular: popular,
            justForYou: justForYou
        )
    }
}

// MARK: - Private Methods
private extension HomePresenter {
  
}
