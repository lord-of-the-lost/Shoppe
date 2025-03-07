//
//  Test.swift
//  Shoppe
//
//  Created by Надежда Капацина on 07.03.2025.

import UIKit

final class TestBasketViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtons()
        updateStatus()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupButtons() {
        let addButton = createButton(
            title: "➕ Добавить товар",
            color: .systemGreen,
            action: #selector(addItem)
        )
        
        let removeButton = createButton(
            title: "➖ Удалить товар",
            color: .systemRed,
            action: #selector(removeItem)
        )
        
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(addButton)
        stackView.addArrangedSubview(removeButton)
    }
    
    // MARK: - Actions
    @objc private func addItem() {
        BasketService.shared.addItem()
        updateStatus()
    }
    
    @objc private func removeItem() {
        BasketService.shared.removeItem()
        updateStatus()
    }
    
    // MARK: - Helpers
    private func createButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func updateStatus() {
        statusLabel.text = "Товаров в корзине: \(BasketService.shared.itemsCount)"
    }
}


