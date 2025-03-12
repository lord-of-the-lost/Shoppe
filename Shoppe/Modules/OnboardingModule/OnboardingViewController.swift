//
//  OnboardingViewController.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 10.03.2025.
//

import UIKit

protocol OnboardingViewProtocol: AnyObject {
    func updatePageControl(currentPage: Int, numberOfPages: Int)
    func updateSlides(slides: [OnboardingViewModel])
    func scrollToPage(at index: Int)
}

final class OnboardingViewController: UIViewController, OnboardingViewProtocol {

    private let presenter: OnboardingPresenterProtocol
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        presenter.loadView()
    }
    
    init(presenter: OnboardingPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - OnboardingViewProtocol
    
    func updatePageControl(currentPage: Int, numberOfPages: Int) {
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = numberOfPages
    }
    
    func updateSlides(slides: [OnboardingViewModel]) {
        var previousSlideView: OnboardingSlideView?
        slides.forEach { viewModel in
            let slideView = OnboardingSlideView()
            slideView.delegate = self
            slideView.configure(with: viewModel)
            slideView.translatesAutoresizingMaskIntoConstraints = false

            scrollView.addSubview(slideView)
            
            NSLayoutConstraint.activate([
                slideView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                slideView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
            
            if let previousSlideView = previousSlideView {
               
                slideView.leadingAnchor.constraint(equalTo: previousSlideView.trailingAnchor).isActive = true
            } else {
                
                slideView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            }
            
            previousSlideView = slideView
        }
        
        if let lastSlideView = previousSlideView {
            lastSlideView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        }
    }
    
    func scrollToPage(at index: Int) {
        let offsetX = CGFloat(index) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter.scrollViewDidScroll(offsetX: scrollView.contentOffset.x)
    }
}

// MARK: - OnboardingSlideDelegate
extension OnboardingViewController: OnboardingSlideDelegate {
    func startButtonTapped() {
        presenter.startButtonTapped()
    }
}

// MARK: - Private Methods
private extension OnboardingViewController {
    func setupView() {
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
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

            
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        presenter.pageControlValueChanged(to: sender.currentPage)
    }
}
