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
    func saveButtonTapped(user: UserSettings)
    func viewDidLoad()
    func didTapEditButton()
    func didSelectImage(_ image: UIImage)
}

// MARK: - Presenter
final class SettingsPresenter: SettingsPresenterProtocol {
    private weak var view: SettingsViewProtocol?
    private weak var viewController: UIViewController?
    private let router: AppRouterProtocol
    var user = UserSettings(username: "username", email: "email", password: "password", avatarData: Data())
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: SettingsViewProtocol, viewController: UIViewController) {
        self.view = view
        self.viewController = viewController
    }
    
    func saveButtonTapped(user: UserSettings) {
        updateUser(username: user.username, email: user.email, password: user.password, image: user.avatarData)
    }
    
    func viewDidLoad() {
        getUser()
        view?.updateUI(user: user)
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
    func updateUser(username: String?, email: String, password: String, image: Data?) {
        let user = UserSettings(username: username ?? "", email: email, password: password, avatarData: image)
        UserDefaultsService.shared.saveCustomObject(user, forKey: .username)
        view?.showAlert(title: "Profile successfully updated", message: nil)
    }
    
    func getUser(){
        guard let user: UserSettings = UserDefaultsService.shared.getCustomObject(forKey: .username) else { return }
        self.user = user
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
