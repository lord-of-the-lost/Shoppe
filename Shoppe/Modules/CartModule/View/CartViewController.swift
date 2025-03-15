//
//  CardViewController.swift
//  Shoppe
//
//  Created by Надежда Капацина on 09.03.2025.
//

import UIKit

protocol CartViewProtocol: AnyObject {
    func updateAddress(_ address: String)
    func reloadCartItems()
    func updateTotalPrice(_ total: String)
}

final class CartViewController: UIViewController {
    private let presenter: CartPresenterProtocol
    private let addressView = AddressView()
    private let tableView = UITableView()
    
    private let footerView = CheckoutFooterView()
    
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
        setupConstraints()
        setupTableView()
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
        
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.reuseID)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        
        footerView.checkoutHandler = { [weak self] in
            self?.checkoutTapped()
        }
        
        [addressView, tableView, footerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
     func setupConstraints() {
        NSLayoutConstraint.activate([
            addressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            addressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: addressView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: addressView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: addressView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -16),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
     func setupTableView() {
        tableView.reloadData()
    }
    
    @objc func checkoutTapped() {
        presenter.showPaymentView()
    }
}
// MARK: - CartViewProtocol
extension CartViewController: CartViewProtocol {
    func reloadCartItems() {
        tableView.reloadData()
    }
    
    func updateTotalPrice(_ total: String) {
        footerView.configure(total: "Total \(total)")
    }
    
    func updateAddress(_ address: String) {
        addressView.configure(with: address)
    }
}
// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartItemCell.reuseID,
            for: indexPath
        ) as! CartItemCell
        
        let item = presenter.cartItems[indexPath.row]
        cell.configure(with: item)
        cell.deleteHandler = { [weak self] in
            self?.presenter.deleteItem(at: indexPath.row)
        }
        cell.increaseHandler = { [weak self] in
            self?.presenter.increaseQuantity(at: indexPath.row)
        }
        cell.decreaseHandler = { [weak self] in
            self?.presenter.decreaseQuantity(at: indexPath.row)
        }
        return cell
    }
}

// MARK: - AddressViewDelegate
extension CartViewController: AddressViewDelegate {
    func editAddressTapped() {
        presenter.editAddressTapped()
    }
}
