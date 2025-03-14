//
//  SearchTextView.swift
//  Shoppe
//
//  Created by Николай Игнатов on 14.03.2025.
//

import UIKit

protocol SearchTextViewDelegate: AnyObject {
    func didTapCross()
}

final class SearchTextView: UIView {
    weak var delegate: SearchTextViewDelegate?
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayMedium16
        label.textColor = UIColor.customBlueText
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var crossButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.customBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(crossTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSearchText(_ text: String) {
        textLabel.text = text
    }
}

// MARK: - Private Methods
private extension SearchTextView {
    func setupView() {
        backgroundColor = .clear
        addSubviews(textLabel, crossButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            crossButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            crossButton.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 10),
            crossButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12),
            crossButton.widthAnchor.constraint(equalToConstant: 10),
            crossButton.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    @objc func crossTapped() {
        delegate?.didTapCross()
    }
}
