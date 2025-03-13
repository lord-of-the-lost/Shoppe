//
//  SettingsViewController.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/12/25.
//


import UIKit

protocol SettingsViewProtocol: AnyObject {
    func updateUI(user: User)
    func updateAvatar(_ image: UIImage)
    func showAlert(title: String, message: String?)
}

final class SettingsViewController: UIViewController {
    private let presenter: SettingsPresenterProtocol
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = Fonts.ralewayBold28
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Profile"
        label.font = Fonts.ralewayMedium16
        return label
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 105 / 2
        containerView.layer.borderWidth = 7
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.16
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        containerView.layer.shadowRadius = 8
        containerView.layer.masksToBounds = false
        return containerView
    }()
    
    private lazy var avatarView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(resource: .avatar)
        logoView.contentMode = .scaleAspectFill
        logoView.layer.cornerRadius = 105 / 2
        logoView.layer.masksToBounds = true
        return logoView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .buttonEdit), for: .normal)
        button.layer.cornerRadius = 92 / 2
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var usernameTF: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Username"
        textField.backgroundColor = .customLighterBlue
        textField.layer.cornerRadius = 9
        return textField
    }()
    
    private lazy var emailTF: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Email"
        textField.backgroundColor = .customLighterBlue
        textField.layer.cornerRadius = 9
        return textField
    }()
    
    private lazy var passwordTF: CustomTextField = {
        let textField = CustomTextField(type: .password)
        textField.placeholder = "Password"
        textField.backgroundColor = .customLighterBlue
        textField.layer.cornerRadius = 9
        return textField
    }()
    
    private lazy var saveButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Save Changes", for: .normal)
        button.titleLabel?.font = Fonts.nunitoLight16
        button.layer.cornerRadius = 9
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    init(presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegate()
        hideKeyboardWhenTappedAround()
    }
}

extension SettingsViewController: SettingsViewProtocol {
    func updateAvatar(_ image: UIImage) {
        avatarView.image = image
    }
    
    func updateUI(user: User) {
        usernameTF.text = user.name
        emailTF.text = user.email
        passwordTF.text = user.password
        avatarView.image = UIImage(data: user.avatarData)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTF {
            emailTF.becomeFirstResponder()
            return false
        }
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
            return false
        }
        if textField == passwordTF {
            textField.resignFirstResponder()
            return true
        }
        return true
    }
}

// MARK: - Private Methods
private extension SettingsViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        [titleLabel, descriptionLabel, containerView, editButton, usernameTF, emailTF, passwordTF, saveButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        containerView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setDelegate() {
        usernameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 74),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            containerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 18),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.heightAnchor.constraint(equalToConstant: 105),
            containerView.widthAnchor.constraint(equalToConstant: 105),
            
            avatarView.topAnchor.constraint(equalTo: containerView.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            avatarView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            avatarView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            editButton.topAnchor.constraint(equalTo: avatarView.topAnchor),
            editButton.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            
            usernameTF.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            usernameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            usernameTF.heightAnchor.constraint(equalToConstant: 50),
            
            emailTF.topAnchor.constraint(equalTo: usernameTF.bottomAnchor, constant: 10),
            emailTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTF.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 10),
            passwordTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTF.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    
    @objc func saveButtonTapped() {
        guard
            let email = emailTF.text, !email.isEmpty,
            let password = passwordTF.text, !password.isEmpty
        else {
            showAlert(title: "Please enter your email and password", message: nil)
            return
        }
        presenter.saveButtonTapped(user: User(
            name: usernameTF.text ?? "",
            email: email,
            password: password,
            avatarData: avatarView.image?.jpegData(compressionQuality: 0.5) ?? .init()))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func editButtonTapped() {
        presenter.didTapEditButton()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}
