//
//  AllCategoriesScreenViewController.swift
//  Shoppe
//
//  Created by Вячеслав on 06.03.2025.
//

import UIKit

protocol AllCategoriesScreenViewProtocol: AnyObject {
    func setTableView()
    func reloadTableView()
}

final class AllCategoriesScreenViewController: UIViewController {

    var presenter: AllCategoriesScreenPresenterProtocol!
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "All Categories"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
//        button.addTarget(AllCategoriesScreenViewController(), action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupLayout()
    }
    
    func cellPressed() {
        presenter.cellPressed()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    private func setupLayout() {
            view.addSubview(titleLabel)
            view.addSubview(closeButton)
            view.addSubview(tableView)

            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            tableView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                // Заголовок
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                
                // Кнопка закрытия
                closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                
                // Таблица
                tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }

    @objc private func closeTapped() {
        print("Close Button Tapped")
    }
    
}

extension AllCategoriesScreenViewController: AllCategoriesScreenViewProtocol {
    func setTableView() {
        
    }
    
    
}

extension AllCategoriesScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath: indexPath)
    }
    
}

extension AllCategoriesScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getCountsOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter.getCellForRowAtIndexPath(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter.getheightForRowAt(indexPath: indexPath)
    }
    
    
}
