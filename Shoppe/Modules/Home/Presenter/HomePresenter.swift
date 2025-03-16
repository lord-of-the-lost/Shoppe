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
    func didTap(action: MainVCInteraction)
    func showDetailView(with product: ProductModel)
    func searchTapped()
    func addressTapped()
}

// MARK: - Presenter
final class HomePresenter {
    private var categories: [CategoryCellViewModel] = []
    private var popular: [PopularCellViewModel] = []
    private var justForYou: [JustForYourCellViewModel] = []
    private weak var view: HomeViewProtocol?
    private let router: AppRouterProtocol
    private let networkService: NetworkServiceProtocol
    private var products: [Product] = [] {
        didSet {
            updateCollections()
        }
    }
    private let dispatchGroup = DispatchGroup()
    
    init(router: AppRouterProtocol, networkService: NetworkServiceProtocol) {
        self.router = router
        self.networkService = networkService
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
    
    func didTap(action: MainVCInteraction) {
        switch action {
        case .searchFieldDidChange(let query):
            handleSearch(query)
        case .didTapCell(let id):
            handleCellTap(id)
        case .didTapSeeAll(let section):
            handleSeeAll(section)
        case .didTapAddToCart(let id):
            handleAddToCart(id)
        }
    }
    
    func showDetailView(with product: ProductModel) {
        //  router.showProductDetail(product)
    }
    
    func searchTapped() {
        router.showSearch(context: .shop(products))
    }
    
    func addressTapped() {
        router.showLocationMap()
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
                guard let image = product.image else { return nil }
                return PopularCellViewModel(
                    id: product.id,
                    image: image,
                    price: product.price,
                    description: product.description
                )
            }
    }
    
    func createJustForYouViewModels() -> [JustForYourCellViewModel] {
        products
            .filter { !$0.isInCart }
            .shuffled()
            .prefix(10)
            .compactMap { product in
                guard let image = product.image else { return nil }
                return JustForYourCellViewModel(
                    id: product.id,
                    image: image,
                    price: String(format: "$%.2f", product.price),
                    description: product.title,
                    isFavorite: product.isInWishlist
                )
            }
    }
    
    func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
            self?.view?.showError(error.localizedDescription)
        }
    }
    
    // MARK: - Action Handlers
    func handleSearch(_ query: String) {
        
    }
    
    func handleCellTap(_ id: Int) {
        guard let product = products.first(where: { $0.id == id }) else { return }
        
    }
    
    func handleSeeAll(_ section: HomeSection) {
        
    }
    
    func handleAddToCart(_ id: Int) {
        guard let index = products.firstIndex(where: { $0.id == id }) else { return }
        products[index].isInCart = true
    }
}

// MARK: - HomeViewProtocol Extension
extension HomeViewProtocol {
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    func showError(_ message: String) {
        
    }
}
