//
//  OnboardingSlideView.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 10.03.2025.
//

import UIKit

protocol OnboardingSlideDelegate: AnyObject {
    func startButtonTapped()
}

struct OnboardingViewModel {
    let image: UIImage
    let header: String
    let description: String
    let isLastSlide: Bool
}

final class OnboardingSlideView: UIView {
    weak var delegate: OnboardingSlideDelegate?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 2, height: 4)
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = Fonts.ralewayBold
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = Fonts.nunitoLight
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Начать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.nunitoLight.withSize(22)
        button.backgroundColor = .customBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ConfigurableViewProtocol
extension OnboardingSlideView: ConfigurableViewProtocol {
    func configure(with model: OnboardingViewModel) {
        imageView.image = model.image
        headerLabel.text = model.header
        descriptionLabel.text = model.description
        startButton.isHidden = !model.isLastSlide
    }
}

// MARK: - Private Methods
private extension OnboardingSlideView {
    func setupView() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(headerLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(startButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.54),
            
            headerLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            headerLabel.heightAnchor.constraint(equalToConstant: 72),
            
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: -10),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            startButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            startButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            startButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            startButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func startButtonTapped() {
        delegate?.startButtonTapped()
    }
}
