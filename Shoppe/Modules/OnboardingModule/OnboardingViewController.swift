//
//  OnboardingViewController.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 10.03.2025.
//

import UIKit

final class OnboardingViewController: UIViewController {
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .backgroundOnboarding))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .customBlue
        control.pageIndicatorTintColor = .customBlueForOnbording
        control.currentPage = 0
        control.numberOfPages = 4
        control.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupSlides()
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / view.bounds.width)
        pageControl.currentPage = Int(page)
    }
}

// MARK: - OnboardingSlideDelegate
extension OnboardingViewController: OnboardingSlideDelegate {
    func startButtonTapped() {
        print("Start button tapped")
    }
}

// MARK: - Private Methods
private extension OnboardingViewController {
    func setupView() {
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        view.addSubview(pageControl)
    }
    
    func setupSlides() {
        sliderData.forEach { viewModel in
            let slideView = OnboardingSlideView()
            slideView.translatesAutoresizingMaskIntoConstraints = false
            slideView.delegate = self
            slideView.configure(with: viewModel)
            
            contentStackView.addArrangedSubview(slideView)
            
            NSLayoutConstraint.activate([
                slideView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        let offsetX = CGFloat(sender.currentPage) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
