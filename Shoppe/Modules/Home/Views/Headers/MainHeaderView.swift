//
//  MainHeaderView.swift
//  Shoppe
//
//  Created by Daniil Murzin on 06.03.2025.
//

import UIKit

protocol MainHeaderViewDelegate: AnyObject {
    func searchTapped()
}

final class MainHeaderView: UIView {
    weak var delegate: MainHeaderViewDelegate?
    
    // MARK: - Drawings
    private enum Drawings {
        static let shopTitle = "Shop"
        static let shopStackSpacing: CGFloat = 20.0
        static let mainStackSpacing: CGFloat = 12.0
        static let sidePadding: CGFloat = 10.0
    }
    
    // MARK: - UI Elements
    private lazy var addressView = HeaderAddressView()
    private lazy var shopTitleView = HomeTitleView(title: Drawings.shopTitle)
    private lazy var searchView = SearchView()
    
    private lazy var shopStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = Drawings.shopStackSpacing
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Drawings.mainStackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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

// MARK: - SearchViewDelegate
extension MainHeaderView: SearchViewDelegate {
    func placeholderTapped() {
        delegate?.searchTapped()
    }
}

// MARK: - Private Methods
private extension MainHeaderView {
    func setupView() {
        backgroundColor = .white
        searchView.delegate = self
        self.translatesAutoresizingMaskIntoConstraints  = false
        shopStackView.addArrangedSubview(shopTitleView)
        shopStackView.addArrangedSubview(searchView)
        
        mainStackView.addArrangedSubview(addressView)
        mainStackView.addArrangedSubview(shopStackView)
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Drawings.sidePadding),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Drawings.sidePadding),
        ])
    }
}
