//
//  StartViewController.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

protocol StartViewProtocol: AnyObject {
}

final class StartViewController: UIViewController {
    private let presenter: StartPresenterProtocol
    
    private lazy var logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "LogoStart")
        logoView.layer.shadowColor = UIColor.black.cgColor
        logoView.layer.shadowOpacity = 0.16
        logoView.layer.shadowOffset = CGSize(width: 0, height: 3)
        logoView.layer.shadowRadius = 8
        return logoView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shoppe"
        label.font = Fonts.ralewayBold52
        return label
    }()
    
    private lazy var startButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Let's get started", for: .normal)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var alreadyText: UILabel = {
        let label = UILabel()
        label.text = "I already have an account"
        label.font = Fonts.nunitoLight15
        return label
    }()
    
    private lazy var alreadyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "buttonArrowRight"), for: .normal)
        button.addTarget(self, action: #selector(alreadyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var alreadyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(alreadyButtonTapped))
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    
    
    init(presenter: StartPresenterProtocol) {
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

extension StartViewController: StartViewProtocol {
    
}

// MARK: - Private Methods
private extension StartViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        [logoView, titleLabel, startButton, alreadyStackView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        alreadyStackView.addArrangedSubview(alreadyText)
        alreadyStackView.addArrangedSubview(alreadyButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 188),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.heightAnchor.constraint(equalToConstant: 134),
            logoView.widthAnchor.constraint(equalToConstant: 134)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: alreadyStackView.topAnchor, constant: -24),
            startButton.heightAnchor.constraint(equalToConstant: 61)
        ])
        
        NSLayoutConstraint.activate([
            alreadyStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alreadyStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -67)
        ])
    }
    
    @objc func startButtonTapped() {
        presenter.startButtonTapped()
    }

    @objc func alreadyButtonTapped() {
        presenter.alreadyButtonTapped()
    }
}
