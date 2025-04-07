//
//  ShippingOptionCell.swift
//  Shoppe
//
//  Created by Daniil Murzin on 11.03.2025.
//


import UIKit

final class ShippingOptionsTableView: UIView {
    
    // MARK: - Properties
    private var selectedIndex: Int = 0
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shipping Options"
        label.font = Fonts.ralewayBold21
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(ShippingOptionCell.self, forCellReuseIdentifier: "ShippingOptionCell")
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.allowsSelection = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 50
        return table
    }()
    
    private lazy var deliveryDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Delivered on or before Thursday, 23 April 2020"
        label.font = Fonts.nunitoRegular
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension ShippingOptionsTableView {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(tableView)
        addSubview(deliveryDateLabel)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            deliveryDateLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            deliveryDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            deliveryDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            deliveryDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension ShippingOptionsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ShippingOptionsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingOptionCell", for: indexPath) as? ShippingOptionCell else {
            fatalError()
        }
        
        if indexPath.row == 0 {
            cell.setMockData(title: "Standard", deliveryTime: "5-7 days", price: "FREE")
        } else {
            cell.setMockData(title: "Express", deliveryTime: "1-2 days", price: "FREE")
        }
        
        let isSelected = indexPath.row == selectedIndex
        cell.setSelectedState(isSelected)
        
        return cell
    }
}
