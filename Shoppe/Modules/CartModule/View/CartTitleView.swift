//
//  CartTitleView.swift
//  Shoppe
//
//  Created by Надежда Капацина on 15.03.2025.
//
import UIKit

final class CartTitleView: UIView {
    
    private let basketService = BasketService.shared
    private var observer: NSObjectProtocol?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cart"
        label.font = Fonts.ralewayBold.withSize(28)
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .customLightBlue
        view.layer.cornerRadius = 12
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold.withSize(18)
        label.textColor = .customBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var updateHandler: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupObservers()
        updateCount()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        
        func updateCount(_ count: Int) {
            countLabel.text = "\(count)"
            countBadge.isHidden = count == 0
            
            UIView.animate(withDuration: 0.2) {
                self.countBadge.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.countBadge.transform = .identity
                }
            }
        }
    }
    func updateCount() { 
        let count = BasketService.shared.totalItemsCount
        countLabel.text = "\(count)"
        countBadge.isHidden = count == 0
        
        UIView.animate(withDuration: 0.2) {
            self.countBadge.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.countBadge.transform = .identity
            }
        }
    }
}
// MARK: - Private Methods
private extension CartTitleView {
    func setupView() {
        addSubview(titleLabel)
        addSubview(countBadge)
        countBadge.addSubview(countLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            countBadge.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            countBadge.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            countBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 24),
            countBadge.heightAnchor.constraint(equalToConstant: 24),
            
            countLabel.centerXAnchor.constraint(equalTo: countBadge.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: countBadge.centerYAnchor),
            countLabel.leadingAnchor.constraint(greaterThanOrEqualTo: countBadge.leadingAnchor, constant: 4),
            countLabel.trailingAnchor.constraint(lessThanOrEqualTo: countBadge.trailingAnchor, constant: -4)
        ])
    }
     func setupObservers() {
        observer = NotificationCenter.default.addObserver(
            forName: .basketDidUpdate,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateCount()
        }
    }
}
