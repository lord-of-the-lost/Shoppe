//
//  LocationPresenterProtocol.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/15/25.
//


import UIKit
import CoreLocation

protocol LocationPresenterProtocol: AnyObject {
    func setupView(_ view: LocationViewProtocol)
    func backButtonTapped()
    func getCurrentLocation() -> CLLocation?
    func requestLocation()
    func saveButtonTapped()
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



