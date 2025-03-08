//
//  CustomTextField.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

class CustomTextField: UITextField {
    private let rightViewPadding: CGFloat = 10
    private let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 50)
    private let toggleButton = UIButton(type: .custom)
    
    var isPasswordField: Bool = false {
        didSet {
            setupTextField()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        self.borderStyle = .none
        self.layer.cornerRadius = 26
        self.font = UIFont.systemFont(ofSize: 16)
        self.backgroundColor = .customGray
        self.textColor = .black
        self.textContentType = .none
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.spellCheckingType = .no
        
        if isPasswordField {
            self.isSecureTextEntry = true
            
            toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
            toggleButton.tintColor = .black
            self.rightView = toggleButton
            self.rightViewMode = .always
        } else {
            self.isSecureTextEntry = false
            self.rightView = nil
        }
    }
    
    @objc private func togglePasswordVisibility() {
        self.isSecureTextEntry.toggle()
        let imageName = self.isSecureTextEntry ? "eye.slash" : "eye"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let width: CGFloat = 50
        let height = bounds.height
        return CGRect(x: bounds.width - width - rightViewPadding, y: 0, width: width, height: height)
    }
}
