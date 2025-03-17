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
    func viewWillAppear()
    func didTap(action: MainVCInteraction)
    func showCategory(_ id: Int)
    func showProductDetail(_ id: Int)
    func searchTapped()
    func addressTapped()
    func cartTapped()
    func addToCartTapped(at index: Int)
    func likeTapped(at index: Int)
}

// MARK: - Presenter
final class HomePresenter {
    private var categories: [CategoryCellViewModel] = []
    private var popular: [PopularCellViewModel] = []
    private var justForYou: [ProductCellViewModel] = []
    private weak var view: HomeViewProtocol?
    private let router: AppRouterProtocol
    private let networkService: NetworkServiceProtocol
    private let basketService: BasketServiceProtocol = BasketService.shared
    private let wishlistService: WishlistServiceProtocol = WishlistService.shared
    private var products: [Product] = [] {
        didSet {
            updateCollections()
        }
    }
    private let dispatchGroup = DispatchGroup()
    
    private var user: User? {
        UserDefaultsService.shared.getCustomObject(forKey: .userModel)
    }
    
    init(router: AppRouterProtocol, networkService: NetworkServiceProtocol) {
        self.router = router
        self.networkService = networkService
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - HomePresenterProtocol
extension HomePresenter: HomePresenterProtocol {
    func setupView(_ view: HomeViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.showLoading()
        fetchData()
    }
    
    func viewWillAppear() {
        syncProductsState()
        updateBasket()
        updateLocationAndCurrency()
    }
    
    func didTap(action: MainVCInteraction) {
        switch action {
        case .didTapCategory(let id):
            showCategory(id)
        case .didTapPopularProduct(let id):
            showProductDetail(id)
        case .didTapJustForYouProduct(let id):
            showProductDetail(id)
        case .didTapSeeAll(let section):
            handleSeeAll(section)
        }
    }
    
    func addToCartTapped(at index: Int) {
        guard let product = products[safe: index] else { return }
        
        let isInCart = basketService.contains(product)
        isInCart ? basketService.removeItem(product) : basketService.addItem(product)
        
        if let currentIndex = products.firstIndex(where: { $0.id == product.id }) {
            products[currentIndex].isInCart = !isInCart
            updateCollections()
        }
    }
    
    func likeTapped(at index: Int) {
        guard let product = products[safe: index] else { return }
        
        let isInWishlist = wishlistService.contains(product)
        isInWishlist ? wishlistService.removeItem(product) : wishlistService.addItem(product)
        
        if let currentIndex = products.firstIndex(where: { $0.id == product.id }) {
            products[currentIndex].isInWishlist = !isInWishlist
            updateCollections()
        }
    }
    
    func showCategory(_ id: Int) {
        router.showCategoriesTabBarItem()
    }
    
    func showProductDetail(_ id: Int) {
        guard let product = products.first(where: { $0.id == id }) else { return }
        router.showProductDetail(product)
    }
    
    func searchTapped() {
        router.showSearch(context: .shop(products))
    }
    
    func addressTapped() {
        router.showLocationMap()
    }
    
    func cartTapped() {
        router.showCartTabBarItem()
    }
}

// MARK: - Private Methods
private extension HomePresenter {
    func fetchData() {
        networkService.fetchAllProducts() { [weak self] result in
            switch result {
            case .success(let products):
                self?.mapProducts(products)
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func mapProducts(_ productModels: [ProductModel]) {
        let queue = DispatchQueue(label: "imageLoadingQueue", attributes: .concurrent)
        var mappedProducts = Array<Product?>(repeating: nil, count: productModels.count)
        
        productModels.enumerated().forEach { index, model in
            dispatchGroup.enter()
            
            queue.async { [weak self] in
                self?.networkService.loadImage(from: model.image) { result in
                    defer { self?.dispatchGroup.leave() }
                    
                    mappedProducts[index] = Product(
                        id: model.id,
                        title: model.title,
                        price: model.price,
                        description: model.description,
                        category: Product.Category(rawValue: model.category.rawValue) ?? .other,
                        imageData: (try? result.get()) ?? Data()
                    )
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.products = mappedProducts.compactMap { $0 }
            self?.view?.hideLoading()
        }
    }
    
    func updateCollections() {
        categories = createCategoryViewModels()
        popular = createPopularViewModels()
        justForYou = createJustForYouViewModels()
        
        view?.updateUI(
            categories: categories,
            popular: popular,
            justForYou: justForYou
        )
    }
    func createCategoryViewModels() -> [CategoryCellViewModel] {
        let groupedProducts = Dictionary(grouping: products) { $0.category }
        
        return groupedProducts.map { category, products in
            let categoryImages = products
                .prefix(4)
                .compactMap { $0.image }
            
            return CategoryCellViewModel(
                id: category.hashValue,
                name: category.displayName,
                images: categoryImages,
                count: products.count
            )
        }.sorted { $0.count > $1.count }
    }
    
    
    func createPopularViewModels() -> [PopularCellViewModel] {
        products
            .sorted { $0.price > $1.price }
            .prefix(5)
            .compactMap { product in
                guard
                    let user,
                    let image = product.image
                else { return nil }
                return PopularCellViewModel(
                    id: product.id,
                    image: image,
                    price: user.currentCurrency.formatPrice(product.price),
                    description: product.description
                )
            }
    }
    
    func createJustForYouViewModels() -> [ProductCellViewModel] {
        products
            .prefix(10)
            .compactMap { product in
                guard
                    let user,
                    let image = product.image
                else { return nil }
                return ProductCellViewModel(
                    id: product.id,
                    image: image,
                    title: product.title,
                    price: user.currentCurrency.formatPrice(product.price),
                    isOnCart: product.isInCart,
                    isOnWishlist: product.isInWishlist
                )
            }
    }
    
    func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
            self?.view?.showError(error.localizedDescription)
        }
    }
    
    func syncProductsState() {
        products = products.map { product in
            var updatedProduct = product
            updatedProduct.isInCart = basketService.contains(product)
            updatedProduct.isInWishlist = wishlistService.contains(product)
            return updatedProduct
        }
    }
    
    func handleSeeAll(_ section: HomeSection) {
        router.showCategoriesTabBarItem()
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBasket),
            name: .basketDidUpdate,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLocationAndCurrency),
            name: .locationAndCurrencyDidUpdate,
            object: nil
        )
    }
    
    @objc func updateBasket() {
        let count = basketService.totalItemsCount
        view?.updateCartBadge(count: count)
    }
    
    @objc private func updateLocationAndCurrency() {
        if let address = user?.address {
            view?.updateAddress(address)
        }
        updateCollections()
    }
}
