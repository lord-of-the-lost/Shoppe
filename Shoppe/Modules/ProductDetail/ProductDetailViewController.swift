//
//  ProductDetailViewController.swift
//  Shoppe
//
//  Created by Николай Игнатов on 08.03.2025.
//

import UIKit

struct ProductDetailViewModel {
    let price: String
    let description: String
    var isLiked: Bool
    var isInCart: Bool
    let images: [UIImage]
}

protocol ProductDetailViewProtocol: AnyObject {
    func updateView(with viewModel: ProductDetailViewModel)
    func updateLikeState(_ isLiked: Bool)
    func updateCartState(_ isInCart: Bool)
}

final class ProductDetailViewController: UIViewController {
    let presenter: ProductDetailPresenterProtocol
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var backButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.backward")
        config.preferredSymbolConfigurationForImage = .init(pointSize: 20, weight: .regular, scale: .default)
        let button = UIButton()
        button.configuration = config
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var imagePagingView: ImagePagingView = {
        let imagePagingView = ImagePagingView()
        imagePagingView.configure(with: [UIImage(resource: .product), UIImage(resource: .product), UIImage(resource: .product), UIImage(resource: .product)])
        imagePagingView.translatesAutoresizingMaskIntoConstraints = false
        return imagePagingView
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.preferredSymbolConfigurationForImage = .init(pointSize: 24, weight: .regular, scale: .default)
        let button = UIButton()
        button.tintColor = .customRed
        button.configuration = config
        button.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var productVariationsView: ProductVariationsView = {
        let view = ProductVariationsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 11
        button.addTarget(self, action: #selector(toggleCart), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buyNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buy now", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.layer.cornerRadius = 11
        button.addTarget(self, action: #selector(buyNowTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    init(presenter: ProductDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ProductViewProtocol
extension ProductDetailViewController: ProductDetailViewProtocol {
    func updateView(with viewModel: ProductDetailViewModel) {
        priceLabel.text = viewModel.price
        descriptionLabel.text = viewModel.description
        imagePagingView.configure(with: viewModel.images)
        updateLikeState(viewModel.isLiked)
        updateCartState(viewModel.isInCart)
    }
    
    func updateLikeState(_ isLiked: Bool) {
        likeButton.setImage(isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
    }
    
    func updateCartState(_ isInCart: Bool) {
        let title = isInCart ? "Remove from cart" : "Add to cart"
        addToCartButton.setTitle(title, for: .normal)
    }
}

// MARK: - Private Methods
private extension ProductDetailViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(scrollView, backButton, buttonStack)
        
        scrollView.addSubviews(imagePagingView, contentStack)
        
        priceStack.addArrangedSubviews(priceLabel, UIView(), likeButton)
        contentStack.addArrangedSubviews(priceStack, descriptionLabel, productVariationsView)
        buttonStack.addArrangedSubviews(addToCartButton, buyNowButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -16),
            
            imagePagingView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imagePagingView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imagePagingView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imagePagingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            imagePagingView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            contentStack.topAnchor.constraint(equalTo: imagePagingView.bottomAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 40),
            
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
            productVariationsView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
    }
    
    @objc private func toggleLike() {
        presenter.toggleLike()
    }
    
    @objc private func toggleCart() {
        presenter.toggleCart()
    }
    
    @objc private func buyNowTapped() {
        presenter.buyNowTapped()
    }
    
    @objc func backButtonTapped() {
        presenter.backButtonTapped()
    }
}
