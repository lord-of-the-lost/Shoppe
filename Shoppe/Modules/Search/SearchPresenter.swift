//
//  SearchPresenter.swift
//  Shoppe
//
//  Created by Николай Игнатов on 11.03.2025.
//

import UIKit

final class SearchPresenter {
    private weak var view: SearchViewProtocol?
    private var searchHistory: [String] = []
    private var currentResults: [ProductCellViewModel] = []
    
    func setupView(_ view: SearchViewProtocol) {
        self.view = view
    }
}

extension SearchPresenter: SearchPresenterProtocol {
    func viewDidLoad() {
        view?.updateState(.empty)
    }
    
    func searchButtonClicked(with text: String) {
        let mockResults = [
            ProductCellViewModel(image: UIImage(named: "product"), description: "Product 1", price: "$17.00"),
            ProductCellViewModel(image: UIImage(named: "product"), description: "Product 2", price: "$17.00")
        ]
        
        if !searchHistory.contains(text) {
            searchHistory.append(text)
        }
        
        currentResults = mockResults
        view?.updateSearchText(text)
        view?.updateState(.results(mockResults))
    }
    
    func clearSearchTapped() {
        view?.updateState(.history(searchHistory))
    }
    
    func addToCartTapped(at index: Int) {
        // Обработка добавления в корзину
    }
    
    func likeTapped(at index: Int) {
        // Обработка добавления в избранное
    }
}
