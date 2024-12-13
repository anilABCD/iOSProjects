

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation? = nil
    @Published var status: CLAuthorizationStatus?
    
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
         
    }
    
    // Callback property
     var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?

    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // Monitor changes in authorization status
       func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           DispatchQueue.main.async {
               self.status = manager.authorizationStatus
               self.onAuthorizationChange?(manager.authorizationStatus)
           }
       }
    func checkLocationStatus() {
        // Retrieve the current authorization status
        status = CLLocationManager.authorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        self.location = latestLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}
