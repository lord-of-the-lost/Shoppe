//
//  CategoriesPresenter.swift
//  Shoppe
//
//  Created by Николай Игнатов on 16.03.2025.
//

import UIKit

struct Category {
    let id: Int
    let title: String
    let items: [Product]
    var isExpanded: Bool
    
    var image: UIImage? {
        items.first?.image
    }
}

protocol CategoriesViewProtocol: AnyObject {
    func updateCategories(_ categories: [Category])
}

final class CategoriesViewController: UIViewController {
    private let presenter: CategoriesPresenterProtocol
    private var categories: [Category] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryHeaderCell.self, forCellReuseIdentifier: CategoryHeaderCell.identifier)
        tableView.register(CategoryProductCell.self, forCellReuseIdentifier: CategoryProductCell.identifier)
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(presenter: CategoriesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        presenter.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let category = categories[safe: section] else { return 0 }
        return category.isExpanded ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let category = categories[safe: indexPath.section] else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategoryHeaderCell.identifier,
                for: indexPath
            ) as? CategoryHeaderCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: category, section: indexPath.section)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategoryProductCell.identifier,
                for: indexPath
            ) as? CategoryProductCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: category.items)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else {
            guard let category = categories[safe: indexPath.section] else { return 0 }
            let itemCount = category.items.count
            let rowCount = ceil(Double(itemCount) / 2.0)
            return rowCount * 60 + (rowCount - 1) * 16
        }
    }
}

// MARK: - CategoryHeaderCellDelegate
extension CategoriesViewController: CategoryHeaderCellDelegate {
    func categoryHeaderCell(_ cell: CategoryHeaderCell, didTapExpandFor section: Int) {
        presenter.toggleCategory(at: section)
    }
}

// MARK: - CategoryProductCellDelegate
extension CategoriesViewController: CategoryProductCellDelegate {
    func categoryProductCell(_ cell: CategoryProductCell, didSelectProduct product: Product) {
        presenter.didSelectProduct(product)
    }
}

// MARK: - CategoriesViewProtocol
extension CategoriesViewController: CategoriesViewProtocol {
    func updateCategories(_ categories: [Category]) {
        self.categories = categories
        tableView.reloadData()
    }
}

// MARK: - Private Methods
private extension CategoriesViewController {
    func setupView() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
