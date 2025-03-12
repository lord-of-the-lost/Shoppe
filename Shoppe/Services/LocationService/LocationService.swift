//
//  LocationService.swift
//  Shoppe
//
//  Created by Кирилл Бахаровский on 3/13/25.
//

import CoreLocation

final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
}
