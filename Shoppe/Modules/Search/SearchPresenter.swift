//
//  SearchPresenter.swift
//  Shoppe
//
//  Created by Николай Игнатов on 11.03.2025.
//

import UIKit

final class SearchPresenter {
    private let router: AppRouterProtocol
    private weak var view: SearchViewProtocol?
    private var searchHistory: [String] = ["product", "pr", "abobus", "aglomeracia", "android-studio kakashka"]
    private var currentResults: [ProductCellViewModel] = []
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: SearchViewProtocol) {
        self.view = view
    }
}

extension SearchPresenter: SearchPresenterProtocol {
    func viewDidLoad() {
        view?.updateState(.history(searchHistory))
    }
    
    func searchButtonClicked(with text: String) {
        let mockResults = [
            ProductCellViewModel(image: UIImage(named: "product"), description: "Product 1", price: "$17.00"),
            ProductCellViewModel(image: UIImage(named: "product"), description: "Product 2", price: "$17.00")
        ]
        
        // Обновляем историю поиска
        if !text.isEmpty {
            // Удаляем текст из истории, если он там уже есть
            searchHistory.removeAll { $0 == text }
            // Добавляем текст в начало массива
            searchHistory.insert(text, at: 0)
        }
        
        currentResults = mockResults
        view?.updateSearchText(text)
        view?.updateState(.history(searchHistory))
      //  view?.updateState(.results(mockResults))
    }
    
    func clearSearchHistoryTapped() {
        searchHistory.removeAll()
        view?.updateState(.empty)
    }
    
    func addToCartTapped(at index: Int) {
        // Обработка добавления в корзину
    }
    
    func likeTapped(at index: Int) {
        // Обработка добавления в избранное
    }
    
    func backButtonTapped() {
        router.popViewController(animated: true)
    }
    
    func removeHistoryItem(at index: Int) {
        searchHistory.remove(at: index)
        if searchHistory.isEmpty {
            view?.updateState(.empty)
        } else {
            view?.updateState(.history(searchHistory))
        }
    }
}
