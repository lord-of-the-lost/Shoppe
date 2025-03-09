//
//  CustomTextField.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

final class CustomTextField: UITextField {
    private let rightViewPadding: CGFloat = 10
    private let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 50)
    private let toggleButton = UIButton(type: .custom)
    private let fieldType: TextFieldType
    
    enum TextFieldType {
        case email
        case password
    }
    
    init(type fieldType: TextFieldType = .email) {
        self.fieldType = fieldType
        super.init(frame: .zero)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        configureCommonSettings()
        
        switch fieldType {
        case .email:
            configureAsEmail()
        case .password:
            configureAsPassword()
        }
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


// MARK: - Private Methods
private extension CustomTextField {
    func configureCommonSettings() {
        borderStyle = .none
        layer.cornerRadius = 26
        font = Fonts.baseFont
        backgroundColor = .customGray
        textColor = .black
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
    }
    
    func configureAsEmail() {
        keyboardType = .emailAddress
        textContentType = .emailAddress
        isSecureTextEntry = false
        rightView = nil
    }
    
    func configureAsPassword() {
        keyboardType = .default
        textContentType = .oneTimeCode
        isSecureTextEntry = true
        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        toggleButton.tintColor = .black
        rightView = toggleButton
        rightViewMode = .always
    }
    
    @objc func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        let imageName = self.isSecureTextEntry ? "eye.slash" : "eye"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
