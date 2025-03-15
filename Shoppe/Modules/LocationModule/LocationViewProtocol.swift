//
//  LocationViewProtocol.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/15/25.
//


import UIKit

protocol LocationViewProtocol: AnyObject {
}

final class LocationMapViewController: UIViewController {
    private let presenter: LocationPresenterProtocol
    
    private lazy var saveButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Сохранить местоположение", for: .normal)
        button.titleLabel?.font = Fonts.nunitoLight16
        button.layer.cornerRadius = 9
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init(presenter: LocationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
}

extension LocationMapViewController: LocationViewProtocol {
}

// MARK: - Private Methods
private extension LocationMapViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubviews(saveButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc func saveButtonTapped() {
    }
}
