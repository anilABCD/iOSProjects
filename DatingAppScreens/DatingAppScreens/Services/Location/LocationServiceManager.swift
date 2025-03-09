import CoreLocation
import SwiftUI
import Combine

class LocationServiceManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var completion: ((Bool) -> Void)?
    @Published var userLocation: CLLocation?
    @AppStorage("location")  var locationString : String = ""
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
       
    }

    // Request location permission
    func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }

    // Handle permission changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            completion?(true)
            DispatchQueue.main.async {
                self.startUpdatingLocation()
            }
        case .denied, .restricted, .notDetermined:
            completion?(false)
        @unknown default:
            completion?(false)
        }
        completion = nil
    }

    // Start fetching location
    func startUpdatingLocation() {
        print("Starting location updates...")
        locationManager.startUpdatingLocation()
    }

    // Stop fetching location when not needed
    func stopUpdatingLocation() {
        print("Stopping location updates...")
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
//        locationManager.delegate = nil  // Completely disables location updates
    }

    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let now = Date()
        
        if ( !locationString.isEmpty ) {
            // Retrieve last update time from UserDefaults
            if let lastUpdate = UserDefaults.standard.object(forKey: "lastUpdateTime") as? Date {
                let timeElapsed = now.timeIntervalSince(lastUpdate)
                if timeElapsed < 3600 {  // 3600 seconds = 1 hour
                    print("Skipping update, only \(Int(timeElapsed)) seconds passed since last update.")
                    return
                }
            }
        }

        // Update userLocation and save timestamp
        DispatchQueue.main.async {
            self.userLocation = location
            self.saveLocation(location)
            UserDefaults.standard.set(now, forKey: "lastUpdateTime")
        }
        
        
        
        print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    // Save location to AppStorage
      private func saveLocation(_ location: CLLocation) {
          let locationString2 = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
          locationString = locationString2
          print("Saved location to AppStorage: \(locationString)")
      }
  
}
