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
}

// MARK: - Presenter
final class HomePresenter {
    private let categories: [CategoryCellViewModel] = Categories.all
    private let popular: [PopularCellViewModel] = PopularMock.all
    private let justForYou: [JustForYourCellViewModel] = JustForYouMock.all
    private weak var view: HomeViewProtocol?
    private let router: AppRouterProtocol
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
}

// MARK: - Private Methods
private extension HomePresenter {}

extension HomePresenter: HomePresenterProtocol {
    func didTap(action: MainVCInteraction) {
    
        switch action {
        case .searchFieldDidChange(_):
            break
        case .didTapCell:
            break
        case .didTapSeeAll:
            break
        case .didTapAddToCart:
            break
        }
    }
    
    func showDetailView(with product: ProductModel) {
        
    }
    
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
    
    func searchTapped() {
        router.showSearch()
    }
}
