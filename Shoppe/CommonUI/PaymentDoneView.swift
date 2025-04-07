//
//  PaymentDoneView.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/15/25.
//

import UIKit

protocol PaymentDoneViewDelegate: AnyObject {
    func trackMyOrderTapped()
}

final class PaymentDoneView: UIView {
    weak var delegate: PaymentDoneViewDelegate?
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .paymentAlert)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.16
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 19
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Done!"
        label.font = Fonts.ralewayBold19
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You card has been successfully charged"
        label.font = Fonts.nunitoSemiBold
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trackMyOrderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Track My Order", for: .normal)
        button.layer.cornerRadius = 11
        button.titleLabel?.font = Fonts.nunitoLight16
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .customGray
        button.addTarget(self, action: #selector(trackMyOrderButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowPath = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: contentView.layer.cornerRadius).cgPath

        logoImageView.layer.shadowPath = UIBezierPath(
            roundedRect: logoImageView.bounds,
            cornerRadius: logoImageView.layer.cornerRadius).cgPath
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        alpha = 0
        backgroundView.alpha = 0
        isHidden = false

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.backgroundView.alpha = 1
        }
    }

}

private extension PaymentDoneView {
    func setupViews() {
        backgroundColor = .clear
        addSubview(backgroundView)
        addSubviews(contentView, logoImageView)
        contentView.addSubviews(titleLabel, descriptionLabel, trackMyOrderButton)
    }
    
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            
            contentView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -40),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 347),
            contentView.heightAnchor.constraint(equalToConstant: 194),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 57),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            trackMyOrderButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            trackMyOrderButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            trackMyOrderButton.widthAnchor.constraint(equalToConstant: 163),
            trackMyOrderButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func trackMyOrderButtonTapped() {
        delegate?.trackMyOrderTapped()
    }
}
