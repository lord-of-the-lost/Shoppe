//
//  PaymentViewProtocol.swift
//  Shoppe
//
//  Created by Daniil Murzin on 11.03.2025.
//


import UIKit

protocol PaymentViewProtocol: AnyObject {
    func updateUI(itemsCount: Int, total: Double)
}

enum PaymentVCInteraction {
    case addressEdit
    case addVoucher
    case paymentMethodEdit
    case payButton
    case itemCell
    case close
    case trackMyOrder
}

final class PaymentViewController: UIViewController {
    private let presenter: PaymentPresenterProtocol

    // MARK: - UI Elements
    private let addressView = PaymentInformationView(type: .contact)
    private let shippingView = PaymentInformationView(type: .shipping)
    private let shippingOptionsTableView = ShippingOptionsTableView()
    private let paymentMethodView = PaymentMethodView()
    private let totalPaymentView = TotalPaymentView()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var paymentDoneView: PaymentDoneView = {
        let view = PaymentDoneView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
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
        let stack = UIStackView(arrangedSubviews: [itemsTitleLabel, itemsCountLabel, UIView(), addVoucherButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
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
        label.font = Fonts.ralewayBold15
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = UIColor.customLightBlue
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addVoucherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Voucher", for: .normal)
        button.titleLabel?.font = Fonts.nunitoRegular
        button.setTitleColor(UIColor.customBlue, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.customBlue.cgColor
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupButtonActions()
        presenter.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableViewHeight()
        tableView.reloadData()
    }

    @objc private func closeTapped() {
        presenter.didTap(action: .close)
    }
}

// MARK: - PaymentViewProtocol
extension PaymentViewController: PaymentViewProtocol {
    func updateUI(itemsCount: Int, total: Double) {
          itemsCountLabel.text = "\(itemsCount)"
          totalPaymentView.updateTotal(to: total)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTapCell(at: indexPath.row)
    }
}

extension PaymentViewController: PaymentDoneViewDelegate {
    func trackMyOrderTapped() {
        presenter.didTap(action: .trackMyOrder)
    }
}

// MARK: - Private Methods
private extension PaymentViewController {
    
    func showPaymentDoneView() {
        let paymentDoneView = PaymentDoneView()
        paymentDoneView.delegate = self
        paymentDoneView.show(in: view)
    }
    
    // MARK: - Button Actions
    func setupButtonActions() {
        addressView.editButton.addAction(
            UIAction { /*[weak self]*/ _ in
                print("addressView tapped")
            },
            for: .touchUpInside
        )
        
        addVoucherButton.addAction(
            UIAction { /*[weak self] _ in*/ _ in
                print("addVoucherButton tapped")
            },
            for: .touchUpInside
        )
        paymentMethodView.editButton.addAction(
            UIAction { /*[weak self]*/ _ in
                print("paymentMethodView  editButton tapped")
            },
            for: .touchUpInside
        )
        totalPaymentView.payButton.addAction(UIAction {/*[ weak self]*/  _ in
            print("payButton tapped")
        }, for: .touchUpInside)
        
        closeButton.addAction(
            UIAction { [weak self] _ in
                self?.presenter.didTap(action: .close)
            },
            for: .touchUpInside
        )
        
        totalPaymentView.payButton.addAction(UIAction { [weak self] _ in
            self?.showPaymentDoneView()
        }, for: .touchUpInside)
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubviews(
            scrollView,
            closeButton,
            paymentDoneView
        )
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews(
            addressView,
            shippingView,
            itemsContainer,
            tableView,
            shippingOptionsTableView,
            paymentMethodView,
            totalPaymentView
        )
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

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            addressView.heightAnchor.constraint(equalToConstant: 80),
            shippingView.heightAnchor.constraint(equalToConstant: 80),
            shippingOptionsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),

            totalPaymentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            totalPaymentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),

            paymentMethodView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),

            itemsCountLabel.widthAnchor.constraint(equalToConstant: 30),
            itemsCountLabel.heightAnchor.constraint(equalToConstant: 30),

            addVoucherButton.heightAnchor.constraint(equalTo: itemsContainer.heightAnchor),
            addVoucherButton.widthAnchor.constraint(equalTo: itemsContainer.widthAnchor, multiplier: 0.25),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            paymentDoneView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentDoneView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            paymentDoneView.widthAnchor.constraint(equalToConstant: 347),
            paymentDoneView.heightAnchor.constraint(equalToConstant: 194)
        ])

        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true

    }
    
    func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableViewHeightConstraint?.constant = contentHeight
        view.layoutIfNeeded()
    }
}
