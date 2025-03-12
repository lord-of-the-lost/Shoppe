//
//  ChipsCollectionViewCell.swift
//  Shoppe
//
//  Created by Николай Игнатов on 11.03.2025.
//

import UIKit

final class ChipsCollectionViewCell: UICollectionViewCell {
    static let identifier = ChipsCollectionViewCell.description()
    
    private lazy var chipsView: ChipsView = {
        let chipsView = ChipsView(cornerRadius: 9)
        chipsView.translatesAutoresizingMaskIntoConstraints = false
        return chipsView
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
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            chipsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            chipsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chipsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chipsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
