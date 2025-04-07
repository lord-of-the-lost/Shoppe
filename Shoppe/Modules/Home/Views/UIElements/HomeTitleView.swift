//
//  HomeTitleView.swift
//  Shoppe
//
//  Created by Daniil Murzin on 06.03.2025.
//


import UIKit

final class HomeTitleView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        titleLabel.font = Fonts.ralewayBold
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        titleLabel.intrinsicContentSize
    }
}
