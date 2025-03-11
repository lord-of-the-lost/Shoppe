//
//  PaymentViewProtocol.swift
//  Shoppe
//
//  Created by Daniil Murzin on 11.03.2025.
//


import UIKit
import SwiftUI

protocol PaymentViewProtocol: AnyObject {}

final class PaymentViewController: UIViewController {
    private let presenter: PaymentPresenterProtocol
    private let addressView  = PaymentInformationView(type: .contact)
    private let shippingView = PaymentInformationView(type: .shipping)
    
    
    init(presenter: PaymentPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
}

// MARK: - PaymentViewProtocol
extension PaymentViewController: PaymentViewProtocol {}

// MARK: - Private Methods
private extension PaymentViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(addressView)
        view.addSubview(shippingView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            addressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            addressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addressView.heightAnchor.constraint(equalToConstant: 80),
            
            shippingView.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 20),
            shippingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shippingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shippingView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

}

//MARK: - SwiftUi preview
struct PVC_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> UIViewController {
            return UINavigationController(
                rootViewController: PaymentFactory.makeModule())
            
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
}
