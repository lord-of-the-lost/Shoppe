//
//  OnboardingCell.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 10.03.2025.
//

import UIKit

struct OnboardingCellViewModel {
    let image: UIImage?
    let header: String
    let description: String
    let button: UIButton?
}

protocol OnboardingCellDelegate: AnyObject {
    func startButtonTapped()
}

final class OnboardingCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = OnboardingCell.description()
    weak var delegate: OnboardingCellDelegate?
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "slideOne")
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Methods
private extension OnboardingCell {
    func setupUI() {
        addSubview(imageView)
        addSubview(headerLabel)
        addSubview(descriptionLabel)
        addSubview(startButton)
        
        // Добавление тени
               layer.shadowColor = UIColor.black.cgColor
               layer.shadowOpacity = 0.4
               layer.shadowOffset = CGSize(width: 2, height: 4)
               layer.shadowRadius = 2
               clipsToBounds = false // Убедитесь, что тень не обрезается
               layer.cornerRadius = 30
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([

            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo:heightAnchor, multiplier: 0.54),
            
            headerLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            headerLabel.heightAnchor.constraint(equalToConstant: 72),
 
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: -10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            descriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 80)
                        
            startButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            startButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func startButtonTapped() {
        delegate?.startButtonTapped()
    }
}

// MARK: - ConfigViewProtocol
extension OnboardingCell: ConfigViewProtocol {
    func configure(with model: OnboardingCellViewModel) {
        imageView.image = model.image
        headerLabel.text = model.header
        descriptionLabel.text = model.description
        startButton.isHidden = model.button == nil
        if let button = model.button {
            startButton.setTitle(button.title(for: .normal), for: .normal)
            startButton.backgroundColor = button.backgroundColor
        }
        descriptionLabel.preferredMaxLayoutWidth = contentView.bounds.width - 60
    }
}
