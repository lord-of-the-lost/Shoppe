//
//  OnboardingViewController.swift
//  Shoppe
//
//  Created by Екатерина Орлова on 10.03.2025.
//

import UIKit

final class OnboardingViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "backgroundOnboarding"))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 25
        collectionView.clipsToBounds = true
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .customBlue
        control.pageIndicatorTintColor = .customBlueForOnbording
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private var sliderData: [OnboardingCellViewModel] = [
        OnboardingCellViewModel(image: UIImage(named: "slideOne"), header: "Welcome!", description: "Discover a fast and easy way to shop online.", button: nil),
        OnboardingCellViewModel(image: UIImage(named: "slideTwo"), header: "Smart Search & Favorites", description: "Find products instantly and save favorites for later.", button: nil),
        OnboardingCellViewModel(image: UIImage(named: "slideThree"), header: "Easy Checkout", description: "Add to cart, choose payment, and order in seconds.", button: nil),
        OnboardingCellViewModel(image: UIImage(named: "slideFour"), header: "Manage Your Store", description: "Become a manager, add products, and control your catalog!", button: {
            let button = UIButton(type: .system)
            button.setTitle("Начать", for: .normal)
            button.backgroundColor = .customBlue
            return button
        }()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstraints()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageNumber
    }
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.identifier, for: indexPath) as? OnboardingCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: sliderData[indexPath.item])
        cell.backgroundColor = .white
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowOffset = CGSize(width: 2, height: 4)
        cell.layer.shadowRadius = 2
        cell.clipsToBounds = false
        cell.layer.cornerRadius = 30
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension OnboardingViewController: OnboardingCellDelegate {
    func startButtonTapped() {
        print("Start button tapped")
    }
}

extension OnboardingViewController {
    func setupUI() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(collectionView)
        backgroundImageView.addSubview(pageControl)
        
    }
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: backgroundImageView.safeAreaLayoutGuide.topAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -70),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor)
        ])
        
        pageControl.numberOfPages = sliderData.count
        pageControl.currentPage = 0
    }
}
