//
//  LocationViewProtocol.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/15/25.
//

import UIKit
import MapKit

protocol LocationViewProtocol: AnyObject {
    func updateMap(with location: CLLocationCoordinate2D, address: String)
}

final class LocationMapViewController: UIViewController {
    private let presenter: LocationPresenterProtocol
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your location"
        label.textColor = .black
        label.font = Fonts.ralewayBold
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.backward")
        config.preferredSymbolConfigurationForImage = .init(pointSize: 20, weight: .regular, scale: .default)
        let button = UIButton()
        button.configuration = config
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private lazy var myLocationButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Save Location", for: .normal)
        button.titleLabel?.font = Fonts.nunitoLight16
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init(presenter: LocationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setupTapGesture()
        
        presenter.setupView(self)
        presenter.requestLocation()
    }
}

extension LocationMapViewController: LocationViewProtocol {
    func updateMap(with location: CLLocationCoordinate2D, address: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.subtitle = address
        annotation.title = "You're here!"
        
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(annotation)
            self.mapView.setCenter(location, animated: true)
        }
    }
}

// MARK: - Private Methods
private extension LocationMapViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(titleLabel, backButton, mapView, saveButton)
        mapView.addSubview(myLocationButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            
            mapView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10),
            
            myLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10),
            myLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10),
            myLocationButton.heightAnchor.constraint(equalToConstant: 40),
            myLocationButton.widthAnchor.constraint(equalToConstant: 40),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc func saveButtonTapped() {
        presenter.saveButtonTapped()
    }
    
    @objc func backButtonTapped() {
        presenter.backButtonTapped()
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }

    @objc func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: mapView)
        let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)

        presenter.didSelectLocation(coordinate)
    }
    
    @objc func myLocationButtonTapped() {
        presenter.myLocationButtonTapped()
    }
}

