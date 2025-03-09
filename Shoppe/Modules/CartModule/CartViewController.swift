//
//  CardViewController.swift
//  Shoppe
//
//  Created by Надежда Капацина on 09.03.2025.
//

import UIKit

protocol CartViewProtocol: AnyObject {
    func updateAddress(_ address: String)
}

final class CartViewController: UIViewController {
    private let presenter: CartPresenterProtocol
    private let addressView = AddressView()
    
    init(presenter: CartPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
    }
    
    
}

// MARK: - Private Methods

private extension CartViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Cart"
        
        addressView.delegate = self
        addressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressView)
        
        NSLayoutConstraint.activate([
            addressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
}
// MARK: - CartViewProtocol
extension CartViewController: CartViewProtocol {
    func updateAddress(_ address: String) {
        addressView.configure(with: address)
    }
}
// MARK: - AddressViewDelegate
extension CartViewController: AddressViewDelegate {
    func editAddressTapped() {
        presenter.editAddressTapped()
    }
}
