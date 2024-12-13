//
//  LocationPermissionManager.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 13/12/24.
//

import CoreLocation
import Combine

class LocationPermissionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var completion: ((Bool) -> Void)?
    
    func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            completion?(true) // Permission granted
        case .denied, .restricted:
            completion?(false) // Permission denied
        case .notDetermined:
            completion?(false)
         
        @unknown default:
            completion?(false)
        }
        completion = nil // Clean up
    }
}


