//
//  ShopTitleView.swift
//  Shoppe
//
//  Created by Daniil Murzin on 06.03.2025.
//


import UIKit

final class ShopTitleView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        titleLabel.font = Fonts.ralewayBold
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
    }
    
    
    override var intrinsicContentSize: CGSize {
        return titleLabel.intrinsicContentSize
    }
}
