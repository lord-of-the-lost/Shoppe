//
//  ProductDetailPresenter.swift
//  Shoppe
//
//  Created by Николай Игнатов on 08.03.2025.
//

import UIKit

protocol ProductDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func toggleLike()
    func toggleCart()
    func buyNowTapped()
}

final class ProductDetailPresenter {
    private weak var view: ProductDetailViewProtocol?
    private var viewModel: ProductDetailViewModel = ProductDetailViewModel(
        price: "$99.99",
        description: "This is a sample product description",
        isLiked: true,
        isInCart: false,
        images: [UIImage(resource: .product), UIImage(resource: .product)]
    )
    
    func setupView(_ view: ProductDetailViewProtocol) {
        self.view = view
    }
}

// MARK: - ProductDetailPresenterProtocol
extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    func viewDidLoad() {
        view?.updateView(with: viewModel)
    }
    
    func toggleLike() {
        viewModel.isLiked.toggle()
        view?.updateLikeState(viewModel.isLiked)
    }
    
    func toggleCart() {
        viewModel.isInCart.toggle()
        view?.updateCartState(viewModel.isInCart)
    }
    
    func buyNowTapped() {
        print(#function)
    }
}
