//
//  SettingsPresenterProtocol.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/12/25.
//


import UIKit
import PhotosUI

protocol SettingsPresenterProtocol: AnyObject {
    func setupView(_ view: SettingsViewProtocol, viewController: UIViewController)
    func saveButtonTapped(user: User)
    func viewDidLoad()
    func viewWillAppear()
    func didTapEditButton()
    func didSelectImage(_ image: UIImage)
}

// MARK: - Presenter
final class SettingsPresenter: SettingsPresenterProtocol {
    private weak var view: SettingsViewProtocol?
    private weak var viewController: UIViewController?
    private let router: AppRouterProtocol
    var user: User? = UserDefaultsService.shared.getCustomObject(forKey: .userModel)
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: SettingsViewProtocol, viewController: UIViewController) {
        self.view = view
        self.viewController = viewController
    }
    
    func saveButtonTapped(user: User) {
        updateUser(username: user.name, email: user.email, password: user.password, image: user.avatarData)
    }
    
    func viewDidLoad() {
        loadUserData()
    }
    
    func viewWillAppear() {
        loadUserData()
    }
    
    func didTapEditButton() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        viewController?.present(picker, animated: true)
    }
    
    func didSelectImage(_ image: UIImage) {
        view?.updateAvatar(image)
    }
}

private extension SettingsPresenter {
    func updateUser(username: String, email: String, password: String, image: Data) {
        guard var user: User = UserDefaultsService.shared.getCustomObject(forKey: .userModel) else { return }
        user.name = username
        user.email = email
        user.password = password
        user.avatarData = image
        UserDefaultsService.shared.saveCustomObject(user, forKey: .userModel)
        view?.showAlert(title: "Profile successfully updated", message: nil)
    }
    
    func loadUserData() {
        guard let user: User = UserDefaultsService.shared.getCustomObject(forKey: .userModel) else { return }
        view?.updateUI(user: user)
    }
}

extension SettingsPresenter: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider else { return }
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                guard let self = self, let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    self.didSelectImage(image)
                }
            }
        }
    }
}
