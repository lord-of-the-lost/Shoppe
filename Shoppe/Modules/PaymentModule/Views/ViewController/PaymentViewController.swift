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
    private let shippingOptionsTableView = ShippingOptionsTableView()
   
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.rowHeight = 105
        return table
    }()
    
    private lazy var ItemsLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold21
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.ralewayBold15
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = UIColor.customLightBlue
        label.layer.cornerRadius = 11
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
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

extension PaymentViewController: UITableViewDelegate {
    
}

extension PaymentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}


// MARK: - Private Methods
private extension PaymentViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(addressView)
        view.addSubview(shippingView)
        view.addSubview(shippingOptionsTableView)
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
            shippingView.heightAnchor.constraint(equalToConstant: 80),
            
            shippingOptionsTableView.topAnchor.constraint(equalTo: shippingView.bottomAnchor, constant: 20),
            shippingOptionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shippingOptionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shippingOptionsTableView.heightAnchor.constraint(equalToConstant: 200),
            
            
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
