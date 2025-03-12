//
//  ImagePagingView.swift
//  Shoppe
//
//  Created by Николай Игнатов on 08.03.2025.
//


import UIKit

final class ImagePagingView: UIView {
    private var images: [UIImage] = []
    private var indicators: [UIView] = []
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var pageIndicatorsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.indicatorSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Configuration
    func configure(with images: [UIImage]) {
        self.images = images
        setupLayout()
        setupImages()
        setupIndicators()
    }
}

// MARK: - UIScrollViewDelegate
extension ImagePagingView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        updateIndicators(at: pageIndex)
    }
}

// MARK: - Private Methods
private extension ImagePagingView {
    enum Constants {
        static let indicatorHeight: CGFloat = 10
        static let inactiveWidth: CGFloat = 10
        static let activeWidth: CGFloat = 40
        static let indicatorSpacing: CGFloat = 8
    }
    
    func setupLayout() {
        addSubview(scrollView)
        addSubview(pageIndicatorsStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            pageIndicatorsStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageIndicatorsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            pageIndicatorsStack.heightAnchor.constraint(equalToConstant: Constants.indicatorHeight)
        ])
    }
    
    func setupImages() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        var previous: UIImageView?
        
        images.forEach {
            let imageView = UIImageView(image: $0)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
            
            if let previous = previous {
                imageView.leadingAnchor.constraint(equalTo: previous.trailingAnchor).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            }
            
            previous = imageView
        }
        
        previous?.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    }
    
    func setupIndicators() {
        indicators.forEach { $0.removeFromSuperview() }
        indicators.removeAll()
        
        for (index, _) in images.enumerated() {
            let indicator = UIView()
            let isFirstIndicator = index == 0
            
            indicator.backgroundColor = isFirstIndicator ? .customBlue : .customBlue.withAlphaComponent(0.2)
            indicator.layer.cornerRadius = Constants.indicatorHeight / 2
            indicator.translatesAutoresizingMaskIntoConstraints = false
            
            let width = isFirstIndicator ? Constants.activeWidth : Constants.inactiveWidth
            NSLayoutConstraint.activate([
                indicator.widthAnchor.constraint(equalToConstant: width),
                indicator.heightAnchor.constraint(equalToConstant: Constants.indicatorHeight)
            ])
            
            indicators.append(indicator)
            pageIndicatorsStack.addArrangedSubview(indicator)
        }
    }
    
    func updateIndicators(at index: Int) {
        UIView.animate(withDuration: 0.3) {
            // Обновляем каждый индикатор
            for (indicatorIndex, indicator) in self.indicators.enumerated() {
                let isActive = indicatorIndex == index
                indicator.backgroundColor = isActive ? .customBlue : .customBlue.withAlphaComponent(0.2)
                let width = isActive ? Constants.activeWidth : Constants.inactiveWidth
                indicator.constraints.first { $0.firstAttribute == .width }?.constant = width
            }
            
            self.layoutIfNeeded()
        }
    }
}
