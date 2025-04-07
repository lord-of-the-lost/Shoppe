//
//  CategoriesPresenter.swift
//  Shoppe
//
//  Created by Николай Игнатов on 16.03.2025.
//

import UIKit

protocol CategoriesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func toggleCategory(at index: Int)
    func didSelectProduct(_ product: Product)
}

final class CategoriesPresenter {
    private weak var view: CategoriesViewProtocol?
    private let router: AppRouterProtocol
    private let networkService: NetworkServiceProtocol
    private var categories: [Category] = []
    
    init(router: AppRouterProtocol, networkService: NetworkServiceProtocol) {
        self.router = router
        self.networkService = networkService
    }
    
    func setupView(_ view: CategoriesViewProtocol) {
        self.view = view
    }
}

extension CategoriesPresenter: CategoriesPresenterProtocol {
    func viewDidLoad() {
        fetchData()
    }
    
    func toggleCategory(at index: Int) {
        guard categories.indices.contains(index) else { return }
        categories[index].isExpanded.toggle()
        view?.updateCategories(categories)
    }
    
    func didSelectProduct(_ product: Product) {
        router.showProductDetail(product)
    }
    
    private func fetchData() {
        networkService.fetchAllProducts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                self.mapProducts(products)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func mapProducts(_ productModels: [ProductModel]) {
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue(label: "imageLoadingQueue", attributes: .concurrent)
        var mappedProducts = Array<Product?>(repeating: nil, count: productModels.count)
        
        productModels.enumerated().forEach { index, model in
            dispatchGroup.enter()
            
            queue.async { [weak self] in
                self?.networkService.loadImage(from: model.image) { result in
                    defer { dispatchGroup.leave() }
                    
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
            guard let self else { return }
            let products = mappedProducts.compactMap { $0 }
            self.createCategories(from: products)
        }
    }
    
    private func createCategories(from products: [Product]) {
        let groupedProducts = Dictionary(grouping: products) { $0.category }
        categories = groupedProducts.map { category, products in
            Category(
                id: category.hashValue,
                title: category.displayName,
                items: products,
                isExpanded: false
            )
        }.sorted { $0.title < $1.title }
        
        view?.updateCategories(categories)
    }
}
