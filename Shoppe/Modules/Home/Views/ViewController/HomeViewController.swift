//
//  ExampleViewProtocol.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//


import UIKit

protocol HomeViewProtocol: AnyObject {}

final class HomeViewController: UIViewController {
    private let presenter: HomePresenterProtocol
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.text = "Exemple"
        label.font = Fonts.baseFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(presenter: HomePresenterProtocol) {
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
    }
}

// MARK: - MainMenuViewProtocol
extension HomeViewController: HomeViewProtocol {}

// MARK: - Private Methods
private extension HomeViewController {
    func setupView() {
        view.backgroundColor = Palette.accentColor
        view.addSubview(screenTitle)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
    }
}
