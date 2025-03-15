//
//  LocationPresenterProtocol.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/15/25.
//


import UIKit
import CoreLocation
import MapKit

protocol LocationPresenterProtocol: AnyObject {
    func setupView(_ view: LocationViewProtocol)
    func backButtonTapped()
    func getCurrentLocation() -> CLLocation?
    func requestLocation()
    func saveButtonTapped()
    func didSelectLocation(_ coordinate: CLLocationCoordinate2D)
    func myLocationButtonTapped()
}

// MARK: - Presenter
final class LocationPresenter: LocationPresenterProtocol {
    private weak var view: LocationViewProtocol?
    private let router: AppRouterProtocol
    private let locationService = LocationService()
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: LocationViewProtocol) {
        self.view = view
        
        print("View set: \(view)")
        locationService.delegate = self
        locationService.requestLocation()
    }
    
    func backButtonTapped() {
        router.popViewController(animated: true)
    }
    
    func saveButtonTapped() {
        
        router.popViewController(animated: true)
    }
    
    func getCurrentLocation() -> CLLocation? {
        locationService.getCurrentLocation()
    }
    
    func requestLocation() {
        locationService.requestLocation()
    }
    
    func didSelectLocation(_ coordinate: CLLocationCoordinate2D) {
        let address = "Custom Location"
        view?.updateMap(with: coordinate, address: address)
    }
    
    func myLocationButtonTapped() {
        guard let location = getCurrentLocation() else { return }
        let coordinate = location.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Your Location"
        view?.updateMap(with: coordinate, address: "Your Location")
    }
}

extension LocationPresenter: LocationServiceDelegate {
    func didUpdateLocation(fullAddress: String, currency: String) {
        guard let location = getCurrentLocation() else { return }
        view?.updateMap(with: location.coordinate, address: fullAddress)
    }
    
    func didFailWithError(_ error: any Error) {
        print(error.localizedDescription)
    }
}



