//
//  ShippingOptionCell.swift
//  Shoppe
//
//  Created by Daniil Murzin on 11.03.2025.
//


import UIKit
import SwiftUI

final class ShippingOptionsTableView: UITableView {
    
    // MARK: - Properties
    private var selectedIndex: Int = 0
    
    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension ShippingOptionsTableView {
    func setupTableView() {
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        dataSource = self
        register(ShippingOptionCell.self, forCellReuseIdentifier: "ShippingOptionCell")
        separatorStyle = .none
    }
}

// MARK: - UITableViewDelegate
extension ShippingOptionsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ShippingOptionsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "ShippingOptionCell", for: indexPath) as! ShippingOptionCell
        
        if indexPath.row == 0 {
            cell.setMockData(title: "Standard", deliveryTime: "5-7 days", price: "FREE")
        } else {
            cell.setMockData(title: "Express", deliveryTime: "1-2 days", price: "$12.00")
        }
        
        let isSelected = indexPath.row == selectedIndex
        cell.setSelectedState(isSelected)
        
        return cell
    }
}
