//
//  CustomButton.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

final class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        setTitleColor(.white, for: .normal)
        backgroundColor = .customBlue
        layer.cornerRadius = 16
        titleLabel?.font = Fonts.nunitoLight22
    }
}
