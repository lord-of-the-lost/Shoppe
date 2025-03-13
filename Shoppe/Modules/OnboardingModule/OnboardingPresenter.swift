//
//  OnboardingPresenter.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 12.03.2025.
//

import UIKit

protocol OnboardingPresenterProtocol {
    func loadView()
    func scrollViewDidScroll(offsetX: CGFloat)
    func pageControlValueChanged(to page: Int)
    func startButtonTapped()
}

final class OnboardingPresenter: OnboardingPresenterProtocol {
    weak var view: OnboardingViewProtocol?
    
    func setupView(_ view: OnboardingViewProtocol) {
        self.view = view
        loadView()
    }
    private let sliderData: [OnboardingViewModel] = [
        OnboardingViewModel(
            image: UIImage(resource: .slideOne),
            header: "Welcome!",
            description: "Discover a fast and easy way to shop online.",
            isLastSlide: false
        ),
        OnboardingViewModel(
            image: UIImage(resource: .slideTwo),
            header: "Smart Search & Favorites",
            description: "Find products instantly and save favorites for later.",
            isLastSlide: false
        ),
        OnboardingViewModel(
            image: UIImage(resource: .slideThree),
            header: "Easy Checkout",
            description: "Add to cart, choose payment, and order in seconds.",
            isLastSlide: false
        ),
        OnboardingViewModel(
            image: UIImage(resource: .slideFour),
            header: "Manage Your Store",
            description: "Become a manager, add products, and control your catalog!",
            isLastSlide: true
        )
    ]
    
    func loadView() {
        view?.updateSlides(slides: sliderData)
        view?.updatePageControl(currentPage: 0, numberOfPages: sliderData.count)
    }
    
    func scrollViewDidScroll(offsetX: CGFloat) {
        let page = round(offsetX / UIScreen.main.bounds.width)
        view?.updatePageControl(currentPage: Int(page), numberOfPages: sliderData.count)
    }
    
    func pageControlValueChanged(to page: Int) {
        view?.scrollToPage(at: page)
    }
    
    func startButtonTapped() {
        let homeVC = HomeFactory.makeModule()
        if let navigationController = (view as? UIViewController)?.navigationController {
            navigationController.pushViewController(homeVC, animated: true)
        }
        print("Start button tapped")
    }
}
