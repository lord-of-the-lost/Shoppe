//
//  ExampleViewProtocol.swift
//  Shoppe
//
//  Created by Daniil Murzin on 04.03.2025.
//

import UIKit
import SwiftUI

protocol HomeViewProtocol: AnyObject {
    func updateUI(
        categories: [CategoryCellViewModel],
        popular: [PopularCellViewModel],
        justForYou: [JustForYourCellViewModel]
    )
}

enum MainVCInteraction {
    case searchFieldDidChange(String)
    case didTapCell
    case didTapSeeAll
    case didTapAddToCart
}

final class HomeViewController: UIViewController {
    
    //MARK: - Properties
    private let presenter: HomePresenterProtocol
    private let dataSource: HomeViewDataSource
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: HomeViewCompLayout.createLayout()
    )
    private let header = MainHeaderView()
    private let sectionHeader = SectionHeader()
    
    //MARK: - Init
    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        self.dataSource = HomeViewDataSource(
            collectionView)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupView()
        setupConstraints()
        presenter.viewDidLoad()
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func didTap(action: MainVCInteraction) {
        
    }
    
    func showDetailView(with product: ProductModel) {
        
    }
    
    func updateUI(
        categories: [CategoryCellViewModel],
        popular: [PopularCellViewModel],
        justForYou: [JustForYourCellViewModel]
    )  {
        dataSource.updateSnapshot(
            categories: categories,
            popular: popular,
            justForYou: justForYou
        )
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        switch dataSource.itemAt(indexPath) {
        case .category(let category):
            print("Category tapped: \(category)")
        
        case .justForYou(let product):
            print("JustForYou tapped: \(product)")
//            presenter.showDetailView(with: product)
            
        case .popular(let product):
            print("Popular tapped: \(product)")
//            presenter.showDetailView(with: product)
            
        case .none:
            assertionFailure("passed invalid IndexPath")
        }
    }
}

// MARK: - Private Methods
private extension HomeViewController {
    
    func setupCollectionView() {
       collectionView.translatesAutoresizingMaskIntoConstraints = false
       collectionView.backgroundColor = .white
       collectionView.delegate = self
   }
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(header)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: - SwiftUi preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> UIViewController {
            return UINavigationController(
                rootViewController: HomeFactory.makeModule())
            
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
        
        typealias UIViewControllerType = UIViewController
    }
}
