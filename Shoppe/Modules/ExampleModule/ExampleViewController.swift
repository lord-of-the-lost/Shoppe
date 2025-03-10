//
//  ExampleViewController.swift
//  Shoppe
//
//  Created by Николай Игнатов on 03.03.2025.
//

import UIKit

protocol ExampleViewProtocol: AnyObject {}

final class ExampleViewController: UIViewController {
    private let presenter: ExamplePresenterProtocol
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.text = "Exemple"
        label.font = Fonts.baseFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(presenter: ExamplePresenterProtocol) {
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
extension ExampleViewController: ExampleViewProtocol {}

// MARK: - Private Methods
private extension ExampleViewController {
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
