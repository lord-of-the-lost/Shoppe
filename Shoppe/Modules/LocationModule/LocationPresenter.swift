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
    
    private var selectedLocation: CLLocation?
    private var selectedAddress: String?
    private var selectedCurrency: Currency?
    
    private var hasRequestedPermission = false
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func setupView(_ view: LocationViewProtocol) {
        self.view = view
        locationService.delegate = self
        locationService.requestLocation()
    }
    
    func backButtonTapped() {
        router.popViewController(animated: true)
    }
    
    func saveButtonTapped() {
        guard let address = selectedAddress, let currency = selectedCurrency else { return }
        saveAddressAndCurrency(address: address, currency: currency)
        sendNotification()
        router.popViewController(animated: true)
    }
    
    func requestLocation() {
        locationService.requestLocation()
    }
    
    func didSelectLocation(_ coordinate: CLLocationCoordinate2D) {
        let selectedLocation: CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        locationService.getAddressAndCurrency(from: selectedLocation) { [weak self] address, currency in
            guard let self else { return }
            self.selectedAddress = address
            self.selectedCurrency = currency
            self.view?.updateMap(with: coordinate, address: self.selectedAddress ?? "Custom Location")
        }
    }
    
    func myLocationButtonTapped() {
        locationService.requestLocation()
        guard let location = locationService.lastLocation else { return }
        selectedLocation = location
        locationService.getAddressAndCurrency(from: location) {
            [weak self] address,
            currency in
            guard let self,
                  let address,
                  let currency
            else { return }
            selectedAddress = address
            selectedCurrency = currency
            view?.updateMap(with: location.coordinate, address: address)
        }
    }
}

private extension LocationPresenter {
    func saveAddressAndCurrency(address: String, currency: Currency) {
        guard var user: User = UserDefaultsService.shared.getCustomObject(forKey: .userModel) else { return }
        user.address = address
        user.currentCurrency = currency
        UserDefaultsService.shared.saveCustomObject(user, forKey: .userModel)
    }
    
    func sendNotification() {
        NotificationCenter.default.post(name: .LocationAndCurrencyDidUpdate, object: nil)
    }
}

// MARK: - LocationServiceDelegate
extension LocationPresenter: LocationServiceDelegate {
    func didUpdateLocation(fullAddress: String, currency: Currency) {
        guard let location = locationService.lastLocation else { return }
        selectedLocation = location
        selectedAddress = fullAddress
        selectedCurrency = currency
        view?.updateMap(with: location.coordinate, address: fullAddress)
    }
    
    func didFailWithError(_ error: any Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
