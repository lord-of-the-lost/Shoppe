//
//  SearchPresenter.swift
//  Shoppe
//
//  Created by Николай Игнатов on 11.03.2025.
//

import UIKit

// MARK: - Protocols
protocol SearchPresenterProtocol: AnyObject {
    func viewDidLoad()
    func searchButtonClicked(with text: String)
    func clearSearchHistoryTapped()
    func clearSearchTapped()
    func addToCartTapped(at index: Int)
    func likeTapped(at index: Int)
    func removeHistoryItem(at index: Int)
    func backButtonTapped()
}

final class SearchPresenter {
    private let router: AppRouterProtocol
    private weak var view: SearchViewProtocol?
    private var searchHistory = ["product", "pr", "abobus", "aglomeracia", "android-studio kakashka"]
    private var currentResults: [ProductCellViewModel] = []
    
    private let mockResults: [ProductCellViewModel] = Array(repeating:
        ProductCellViewModel(
            image: UIImage(named: "product"),
            description: "Lorem ipsum dolor sit amet consectetur",
            price: "$17.00"
        ), count: 8)
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: SearchViewProtocol) {
        self.view = view
    }
}

// MARK: - SearchPresenterProtocol
extension SearchPresenter: SearchPresenterProtocol {
    func viewDidLoad() {
        updateViewState(.history(searchHistory))
    }
    
    func searchButtonClicked(with text: String) {
        guard !text.isEmpty else { return }
        
        searchHistory.removeAll { $0 == text }
        searchHistory.insert(text, at: 0)
        currentResults = mockResults
        
        view?.updateSearchText(text)
        updateViewState(.results(mockResults))
    }
    
    func clearSearchHistoryTapped() {
        searchHistory.removeAll()
        updateViewState(.empty)
    }
    
    func clearSearchTapped() {
        updateViewState(.history(searchHistory))
    }
    
    func addToCartTapped(at index: Int) {
        print(#function)
    }
    
    func likeTapped(at index: Int) {
        print(#function)
    }
    
    func backButtonTapped() {
        router.popViewController(animated: true)
    }
    
    func removeHistoryItem(at index: Int) {
        guard searchHistory.indices.contains(index) else { return }
        
        searchHistory.remove(at: index)
        updateViewState(searchHistory.isEmpty ? .empty : .history(searchHistory))
    }
}

// MARK: - Private Methods
private extension SearchPresenter {
    func updateViewState(_ state: SearchState) {
        view?.updateState(state)
    }
}
