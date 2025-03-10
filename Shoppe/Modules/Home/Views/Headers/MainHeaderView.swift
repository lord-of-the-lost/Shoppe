//
//  MainHeaderView.swift
//  Shoppe
//
//  Created by Daniil Murzin on 06.03.2025.
//

import UIKit
import SwiftUI

final class MainHeaderView: UIView {
    
    // MARK: - Drawings
    private enum Drawings {
        static let shopTitle = "Shop"
        static let shopStackSpacing: CGFloat = 20.0
        static let mainStackSpacing: CGFloat = 12.0
        static let sidePadding: CGFloat = 10.0
    }
    
    // MARK: - UI Elements
    private let addressView = AddressView()
    private let shopTitleView = HomeTitleView(title: Drawings.shopTitle)
    private let searchBarView = SearchBarView()
    
    private let shopStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Drawings.shopStackSpacing
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Drawings.mainStackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension MainHeaderView {
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints  = false
        shopStackView.addArrangedSubview(shopTitleView)
        shopStackView.addArrangedSubview(searchBarView)
        
        mainStackView.addArrangedSubview(addressView)
        mainStackView.addArrangedSubview(shopStackView)
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Drawings.sidePadding),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Drawings.sidePadding),
        ])
    }
}

// MARK: - SwiftUI Preview
struct MainHeaderViewPreview: PreviewProvider {
    static var previews: some View {
        MainHeaderViewPreviewWrapper()
            .previewLayout(.sizeThatFits)
            .padding()
            .frame(height: 120)
    }
}

struct MainHeaderViewPreviewWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> MainHeaderView {
        return MainHeaderView()
    }
    
    func updateUIView(_ uiView: MainHeaderView, context: Context) {}
}
