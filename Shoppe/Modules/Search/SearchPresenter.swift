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
    func viewWillAppear()
    func searchButtonClicked(with text: String)
    func clearSearchHistoryTapped()
    func clearSearchTapped()
    func addToCartTapped(at index: Int)
    func likeTapped(at index: Int)
    func removeHistoryItem(at index: Int)
    func backButtonTapped()
    func showProductDetail(at index: Int)
}

final class SearchPresenter {
    // MARK: - Properties
    private let products: [Product]
    private let router: AppRouterProtocol
    private let userDefaultsService: UserDefaultsService
    private let basketService: BasketServiceProtocol
    private let wishlistService: WishlistServiceProtocol
    private weak var view: SearchViewProtocol?
    private var searchHistory: [String] = []
    private var currentResults: [Product] = []
    
    // MARK: - Initialization
    init(
        products: [Product],
        router: AppRouterProtocol,
        userDefaultsService: UserDefaultsService,
        basketService: BasketServiceProtocol = BasketService.shared,
        wishlistService: WishlistServiceProtocol = WishlistService.shared
    ) {
        self.products = products
        self.router = router
        self.userDefaultsService = userDefaultsService
        self.basketService = basketService
        self.wishlistService = wishlistService
        loadSearchHistory()
    }
    
    func setupView(_ view: SearchViewProtocol) {
        self.view = view
    }
}

// MARK: - SearchPresenterProtocol
extension SearchPresenter: SearchPresenterProtocol {
    func viewDidLoad() {
        let viewState: SearchState = searchHistory.isEmpty ? .empty : .history(searchHistory)
        updateViewState(viewState)
    }
    
    func viewWillAppear() {
        guard !currentResults.isEmpty else { return }
        syncProductsState()
        updateViewState(.results(mapCurrentResultsToViewModels()))
    }
    
    func searchButtonClicked(with text: String) {
        guard !text.isEmpty else { return }
        
        searchHistory.removeAll { $0 == text }
        searchHistory.insert(text, at: 0)
        saveSearchHistory()
        
        currentResults = products.filter { product in
            product.title.lowercased().contains(text.lowercased()) ||
            product.description.lowercased().contains(text.lowercased()) ||
            product.category.displayName.lowercased().contains(text.lowercased())
        }
        
        syncProductsState()
        view?.updateSearchText(text)
        updateViewState(.results(mapCurrentResultsToViewModels()))
    }
    
    func clearSearchHistoryTapped() {
        searchHistory.removeAll()
        saveSearchHistory()
        updateViewState(.empty)
    }
    
    func clearSearchTapped() {
        currentResults.removeAll()
        updateViewState(.history(searchHistory))
    }
    
    func showProductDetail(at index: Int) {
        guard let product = currentResults[safe: index] else { return }
        router.showProductDetail(product)
    }
    
    func addToCartTapped(at index: Int) {
        guard let product = currentResults[safe: index] else { return }
        
        let isInCart = basketService.contains(product)
        isInCart ? basketService.removeItem(product) : basketService.addItem(product)
        
        if let currentIndex = currentResults.firstIndex(where: { $0.id == product.id }) {
            currentResults[currentIndex].isInCart = !isInCart
            updateViewState(.results(mapCurrentResultsToViewModels()))
        }
    }

    func likeTapped(at index: Int) {
        guard let product = currentResults[safe: index] else { return }
        
        let isInWishlist = wishlistService.contains(product)
        isInWishlist ? wishlistService.removeItem(product) : wishlistService.addItem(product)
        
        if let currentIndex = currentResults.firstIndex(where: { $0.id == product.id }) {
            currentResults[currentIndex].isInWishlist = !isInWishlist
            updateViewState(.results(mapCurrentResultsToViewModels()))
        }
    }
    
    func removeHistoryItem(at index: Int) {
        guard searchHistory[safe: index] != nil else { return }
        
        searchHistory.remove(at: index)
        saveSearchHistory()
        updateViewState(searchHistory.isEmpty ? .empty : .history(searchHistory))
    }
    
    func backButtonTapped() {
        router.popViewController(animated: true)
    }
}

// MARK: - Private Methods
private extension SearchPresenter {
    func mapCurrentResultsToViewModels() -> [ProductCellViewModel] {
        currentResults.map { product in
            ProductCellViewModel(
                image: product.image,
                title: product.title,
                price: String(format: "$%.2f", product.price),
                isOnCart: product.isInCart,
                isOnWishlist: product.isInWishlist
            )
        }
    }
    
    func updateViewState(_ state: SearchState) {
        view?.updateState(state)
    }
    
    func syncProductsState() {
        currentResults = currentResults.map { product in
            var updatedProduct = product
            updatedProduct.isInCart = basketService.contains(product)
            updatedProduct.isInWishlist = wishlistService.contains(product)
            return updatedProduct
        }
    }
    
    func loadSearchHistory() {
        guard let user: User = userDefaultsService.getCustomObject(forKey: .userModel) else { return }
        searchHistory = user.searchHistory
    }
    
    func saveSearchHistory() {
        guard var user: User = userDefaultsService.getCustomObject(forKey: .userModel) else { return }
        user.searchHistory = searchHistory
        userDefaultsService.saveCustomObject(user, forKey: .userModel)
    }
}
