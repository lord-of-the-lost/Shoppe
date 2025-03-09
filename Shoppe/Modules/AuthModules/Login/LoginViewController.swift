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
    func updateNextButtonTitle(_ title: String)
    func updateCancelButtonTitle(_ title: String) 
    func switchToPasswordField(is bool: Bool)
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
    func showAlert(title: String, message: String?)
    func hideKeyboard()
}

final class LoginViewController: UIViewController {
    private let presenter: LoginPresenterProtocol
    
    private lazy var backgroundView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(resource: .backgroundLogin)
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
        let textField = CustomTextField(type: .password)
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isHidden = true
        return textField
    }()
    
    private lazy var nextButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
        addKeyboardObservers()
        setDelegate()
    }
    
    deinit {
        removeKeyboardObservers()
    }
}

extension LoginViewController: LoginViewProtocol {
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(height: CGFloat) {
        if emailTextField.isFirstResponder || passwordTextField.isFirstResponder {
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
    
    func updateNextButtonTitle(_ title: String) {
        nextButton.setTitle(title, for: .normal)
    }
    
    func updateCancelButtonTitle(_ title: String) {
        cancelLabel.text = title
    }
    
    func switchToPasswordField(is bool: Bool) {
        emailTextField.isHidden = bool
        passwordTextField.isHidden = !bool
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            presenter.nextButtonTapped()
            return false
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
            presenter.nextButtonTapped()
            return true
        }
        return true
    }
}

// MARK: - Private Methods
private extension LoginViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        [backgroundView, titleLabel, descriptionLabel, emailTextField, passwordTextField, nextButton, cancelLabel].forEach {
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
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        
            descriptionLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
       
            emailTextField.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -37),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 52),
       
            passwordTextField.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -37),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 52),
        
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: cancelLabel.topAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 61),
        
            cancelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -67)
        ])
    }
    
    @objc func nextButtonTapped() {
        presenter.nextButtonTapped()
    }
    
    @objc func cancelButtonTapped() {
        presenter.cancelButtonTapped()
    }
    
    @objc func dismissKeyboard() {
        hideKeyboard()
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
