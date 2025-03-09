//
//  LoginViewController.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/6/25.
//


import UIKit

protocol RegisterViewProtocol: AnyObject {
    func getEmail() -> String?
    func getPassword() -> String?
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
    func showAlert(title: String, message: String?)
}

final class RegisterViewController: UIViewController {
    private let presenter: RegisterPresenterProtocol
    
    private lazy var backgroundView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(resource: .backgroundCreateAccount)
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
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(type: .password)
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 14)
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
        addKeyboardObservers()
        setDelegate()
    }
    
    deinit {
        removeKeyboardObservers()
    }
}

extension RegisterViewController: RegisterViewProtocol {
    func keyboardWillShow(height: CGFloat) {
        if passwordTextField.isFirstResponder {
            let distanceFromBottom = getDistanceFromBottom(textField: passwordTextField)
            
            if distanceFromBottom < height {
                let offset = height - distanceFromBottom
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = -offset - 8
                }
            }
        }
    }
    
    func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    func getEmail() -> String? {
        emailTextField.text
    }
    
    func getPassword() -> String? {
        passwordTextField.text
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            return false
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
            return true
        }
        return true
    }
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
    
    func setDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 122),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: 250),
            
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 52),
            
            passwordTextField.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -61),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 52),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: cancelLabel.topAnchor, constant: -24),
            doneButton.heightAnchor.constraint(equalToConstant: 61),
            
            cancelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -67)
        ])
    }
    
    @objc func doneButtonTapped() {
        presenter.doneButtonTapped(email: getEmail(), password: getPassword())
    }
    
    @objc func cancelButtonTapped() {
        presenter.cancelButtonTapped()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        presenter.keyboardWillShow(height: keyboardFrame.height)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        presenter.keyboardWillHide()
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    func getDistanceFromBottom(textField: UITextField) -> CGFloat {
        let textFieldBottomY = textField.frame.maxY
        let viewBottomY = view.frame.height
        return viewBottomY - textFieldBottomY
    }
}
