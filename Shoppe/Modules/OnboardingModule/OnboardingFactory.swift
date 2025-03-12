//
//  OnboardingFactory.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 12.03.2025.
//

import UIKit

enum OnboardingFactory {
    static func makeModule() -> UIViewController {
        let presenter = OnboardingPresenter()
        let viewController = OnboardingViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
