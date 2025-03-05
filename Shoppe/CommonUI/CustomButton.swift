//
//  CustomButton.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .blue
        self.layer.cornerRadius = 16
        self.titleLabel?.font = Fonts.nunitoLight22
    }
}
