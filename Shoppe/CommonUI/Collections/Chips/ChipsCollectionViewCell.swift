//
//  ChipsCollectionViewCell.swift
//  Shoppe
//
//  Created by Николай Игнатов on 11.03.2025.
//

import UIKit

protocol ChipsCollectionViewCellDelegate: AnyObject {
    func deleteButtonTapped(in cell: ChipsCollectionViewCell)
}

final class ChipsCollectionViewCell: UICollectionViewCell {
    weak var delegate: ChipsCollectionViewCellDelegate?
    static let identifier = ChipsCollectionViewCell.description()
  
    private lazy var chipsView: ChipsView = {
        let chipsView = ChipsView(cornerRadius: 9)
        chipsView.translatesAutoresizingMaskIntoConstraints = false
        return chipsView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
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
extension ChipsCollectionViewCell: ConfigurableViewProtocol {
    func configure(with text: String) {
        chipsView.configure(with: text)
    }
}

// MARK: - Private Methods
private extension ChipsCollectionViewCell {
    func setupView() {
        contentView.addSubview(chipsView)
        contentView.addSubview(deleteButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            chipsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            chipsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chipsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: chipsView.trailingAnchor, constant: 4),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            deleteButton.widthAnchor.constraint(equalToConstant: 10),
            deleteButton.heightAnchor.constraint(equalToConstant: 10),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc func deleteButtonTapped() {
        delegate?.deleteButtonTapped(in: self)
    }
}
