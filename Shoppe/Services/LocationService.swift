//
//  LocationService.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/13/25.
//

import CoreLocation
import UIKit

protocol LocationServiceDelegate: AnyObject {
    func didUpdateLocation(fullAddress: String, currency: Currency)
    func didFailWithError(_ error: Error)
}

/// LocationService отвечает за получение текущей геолокации и определение валюты по стране.
/// Использует CLLocationManager для получения координат и CLGeocoder для обратного геокодинга.
final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private(set) var lastLocation: CLLocation?
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            showLocationDeniedAlert()
            delegate?.didFailWithError(NSError(
                domain: "Location error",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Access to location is denied."]
            ))
        default:
            break
        }
    }
    
    func getAddressAndCurrency(from location: CLLocation, completion: @escaping (String?, Currency?) -> Void) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, error == nil, let placemark = placemarks?.first else {
                completion(nil, nil)
                self?.delegate?.didFailWithError(NSError(
                    domain: "Geocode error",
                    code: 2,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve address."])
                )
                return
            }
            
            let countryCode = placemark.isoCountryCode ?? "Unknown"
            let currency = self.getCurrency(countryCode: countryCode)
            let address = [placemark.country, placemark.administrativeArea, placemark.locality]
                .compactMap { $0 }
                .joined(separator: ", ")
            
            completion(address, currency)
        }
    }
    
    private func getCurrency(countryCode: String) -> Currency {
        let europeCountries = ["FR", "DE", "IT", "ES", "NL", "BE", "AT", "PT", "FI", "IE", "GR", "LU", "SK", "SI", "LV", "LT", "EE", "CY", "MT"]
        if countryCode == "RU" {
            return .ruble
        } else if europeCountries.contains(countryCode) {
            return .euro
        } else {
            return .dollar
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        
        getAddressAndCurrency(from: location) { [weak self] address, currency in
            guard let address = address, let currency = currency else { return }
            self?.delegate?.didUpdateLocation(fullAddress: address, currency: currency)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}

// MARK: - Location Access Alert
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
