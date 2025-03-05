//
//  RegisterViewController.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

protocol RegisterViewProtocol: AnyObject {
}

final class RegisterViewController: UIViewController {
    private let presenter: RegisterPresenterProtocol
    
    private lazy var backgroundView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "backgroundCreateAccount")
        return logoView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = Fonts.ralewayBold50
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Email"
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isPasswordField = true
        return textField
    }()
    
    private lazy var doneButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
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
    
    
    init(presenter: RegisterPresenterProtocol) {
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

extension RegisterViewController: RegisterViewProtocol {
}

// MARK: - Private Methods
private extension RegisterViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        [backgroundView, titleLabel, emailTextField, passwordTextField, doneButton, cancelLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 122),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -61),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: cancelLabel.topAnchor, constant: -24),
            doneButton.heightAnchor.constraint(equalToConstant: 61)
        ])
        
        NSLayoutConstraint.activate([
            cancelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -67)
        ])
    }
    
    @objc func doneButtonTapped() {
        presenter.doneButtonTapped()
    }
    
    @objc func cancelButtonTapped() {
        presenter.cancelButtonTapped()
    }
}

extension RegisterViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
