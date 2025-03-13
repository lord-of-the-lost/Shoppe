//
//  LocationService.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/13/25.
//

import CoreLocation
import UIKit

protocol LocationServiceDelegate: AnyObject {
    func didUpdateLocation(countryCode: String, currency: String)
    func didFailWithError(_ error: Error)
}

/// LocationService отвечает за получение текущей геолокация и определяет валюту по стране.
/// Использует CLLocationManager для получения координат и CLGeocoder для обратного геокодинга.

final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            showLocationDeniedAlert()
            delegate?.didFailWithError(NSError(
                domain: "Location error",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Access to location is denied."]))
        default:
            break
        }
    }
    
    private func fetchCountryAndCurrency(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, error == nil, let countryCode = placemarks?.first?.isoCountryCode else {
                self?.delegate?.didFailWithError(NSError(
                    domain: "Geocode error",
                    code: 2,
                    userInfo: [NSLocalizedDescriptionKey: "Country detection failed"]))
                return
            }
            let currency = getCurrency(countryCode: countryCode)
            self.delegate?.didUpdateLocation(countryCode: countryCode, currency: currency)
        }
    }
    
    private func getCurrency(countryCode: String) -> String {
        let europeCountries = ["FR", "DE", "IT", "ES", "NL", "BE", "AT", "PT", "FI", "IE", "GR", "LU", "SK", "SI", "LV", "LT", "EE", "CY", "MT"]
        if countryCode == "RU" {
            return "₽"
        } else if europeCountries.contains(countryCode) {
            return "€"
        } else {
            return "$"
        }
    }
}

// MARK: - CLLocationManagerDelegate
// Handling location updates and error cases
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchCountryAndCurrency(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        delegate?.didFailWithError(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}

// MARK: - Create LocationAlert
extension LocationService {
    private func showLocationDeniedAlert() {
        guard let topVC = UIApplication.shared.delegate?.window??.rootViewController else { return }
        
        let alert = UIAlertController(
            title: "Location Access Denied",
            message: "Please enable location access in Settings.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        
        DispatchQueue.main.async {
            topVC.present(alert, animated: true)
        }
    }
}
