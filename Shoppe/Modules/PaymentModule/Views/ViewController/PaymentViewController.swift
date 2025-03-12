//
//  PaymentViewProtocol.swift
//  Shoppe
//
//  Created by Daniil Murzin on 11.03.2025.
//


import UIKit
import SwiftUI

protocol PaymentViewProtocol: AnyObject {
    func reloadData()
}

final class PaymentViewController: UIViewController {
    private let presenter: PaymentPresenterProtocol

    // MARK: - UI Elements
    private let addressView = PaymentInformationView(type: .contact)
    private let shippingView = PaymentInformationView(type: .shipping)
    private let shippingOptionsTableView = ShippingOptionsTableView()
    private let paymentMethodView = PaymentMethodView()
    private let totalPaymentView = TotalPaymentView()

    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var itemsContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [itemsTitleLabel, itemsCountLabel, addVoucherButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var itemsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Items"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var itemsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = UIColor.systemGray5
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addVoucherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Voucher", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.rowHeight = 70
        return table
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    init(presenter: PaymentPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        presenter.viewDidLoad()
        updateTableViewHeight()
    }
    
    private func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableViewHeightConstraint?.constant = contentHeight
        view.layoutIfNeeded()
    }
}

// MARK: - PaymentViewProtocol
extension PaymentViewController: PaymentViewProtocol {
    func reloadData() {
        tableView.reloadData()
        updateTableViewHeight()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ItemTableViewCell.reuseIdentifier, for: indexPath
        ) as? ItemTableViewCell else {
            fatalError("Unable to dequeue ItemTableViewCell")
        }
        
        let itemViewModel = presenter.item(at: indexPath.row)
        cell.configure(with: itemViewModel)
        return cell
    }
}

// MARK: - Private Methods
private extension PaymentViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(addressView)
        stackView.addArrangedSubview(shippingView)
        stackView.addArrangedSubview(itemsContainer)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(shippingOptionsTableView)
        stackView.addArrangedSubview(paymentMethodView)
        stackView.addArrangedSubview(totalPaymentView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            addressView.heightAnchor.constraint(equalToConstant: 80),
            shippingView.heightAnchor.constraint(equalToConstant: 80),
            shippingOptionsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            paymentMethodView.heightAnchor.constraint(equalToConstant: 100),
            totalPaymentView.heightAnchor.constraint(equalToConstant: 80)
        ])

        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
    }
}

// MARK: - SwiftUI Preview
struct PVC_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return UINavigationController(rootViewController: PaymentFactory.makeModule())
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
}
