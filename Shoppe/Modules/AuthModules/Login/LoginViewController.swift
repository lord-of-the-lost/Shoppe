//
//  LoginViewController.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

protocol LoginViewProtocol: AnyObject {
    func getEmail() -> String?
    func getPassword() -> String?
    func updateButtonTitle(_ title: String)
    func switchToPasswordField()
}

final class LoginViewController: UIViewController {
    private let presenter: LoginPresenterProtocol
    
    private lazy var backgroundView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "backgroundLogin")
        return logoView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = Fonts.ralewayBold50
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Good to see you back! 🖤"
        label.font = Fonts.nunitoLight
        label.textAlignment = .left
        return label
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Email"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isPasswordField = true
        return textField
    }()
    
    private lazy var nextButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelLabel: UILabel = {
        let label = UILabel()
        label.text = "Cancel"
        label.font = Fonts.nunitoLight15
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    
    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        hideKeyboardWhenTappedAround()
    }
}

extension LoginViewController: LoginViewProtocol {
    func getEmail() -> String? {
        return emailTextField.text
    }
    
    func getPassword() -> String? {
        return passwordTextField.text
    }
    
    func updateButtonTitle(_ title: String) {
        nextButton.setTitle(title, for: .normal)
    }
    
    func switchToPasswordField() {
        emailTextField.isHidden = true
        passwordTextField.isHidden = false
    }
}

// MARK: - Private Methods
private extension LoginViewController {
    func setupViews() {
        view.backgroundColor = .white
        passwordTextField.isHidden = true
        
        [backgroundView, titleLabel, descriptionLabel, emailTextField, passwordTextField, nextButton, cancelLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -37),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -37),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: cancelLabel.topAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 61)
        ])
        
        NSLayoutConstraint.activate([
            cancelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -67)
        ])
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        presenter.nextButtonTapped(button: sender)
    }
    
    @objc func cancelButtonTapped() {
        presenter.cancelButtonTapped()
    }
}

extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
