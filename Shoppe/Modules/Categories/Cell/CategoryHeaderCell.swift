//
//  CategoryHeaderCell.swift
//  Shoppe
//
//  Created by Николай Игнатов on 17.03.2025.
//

import UIKit

protocol CategoryHeaderCellDelegate: AnyObject {
    func categoryHeaderCell(_ cell: CategoryHeaderCell, didTapExpandFor section: Int)
}

final class CategoryHeaderCell: UITableViewCell {
    static let identifier = "CategoryHeaderCell"
    
    weak var delegate: CategoryHeaderCellDelegate?
    private var section: Int = 0
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        setupGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: Category, section: Int) {
        self.section = section
        image.image = category.image
        titleLabel.text = category.title
        arrowImageView.transform = category.isExpanded ?
            CGAffineTransform(rotationAngle: .pi) : .identity
        arrowImageView.tintColor = category.isExpanded ? .systemBlue : .black
    }
}

// MARK: - Private Methods
private extension CategoryHeaderCell {
    func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubview(image)
        containerView.addSubview(titleLabel)
        containerView.addSubview(arrowImageView)
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            image.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            image.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: 40),
            image.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc func containerTapped() {
        delegate?.categoryHeaderCell(self, didTapExpandFor: section)
    }
}
