import CoreLocation
import SwiftUI
import Combine

class LocationPermissionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var completion: ((Bool) -> Void)?
    @Published var userLocation: CLLocation?
    @AppStorage("location") private var locationString : String = ""
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        loadSavedLocation()
    }

    // Request location permission
    func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
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
//        locationManager.delegate = nil  // Completely disables location updates
    }

    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let now = Date()
        
        // Retrieve last update time from UserDefaults
        if let lastUpdate = UserDefaults.standard.object(forKey: "lastUpdateTime") as? Date , let userlocation = self.userLocation {
            let timeElapsed = now.timeIntervalSince(lastUpdate)
            if timeElapsed < 3600 {  // 3600 seconds = 1 hour
                print("Skipping update, only \(Int(timeElapsed)) seconds passed since last update.")
                return
            }
        }

        // Update userLocation and save timestamp
        DispatchQueue.main.async {
            self.userLocation = location
            self.saveLocation(location)
        }
        
        
        
        print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    // Save location to AppStorage
      private func saveLocation(_ location: CLLocation) {
          let locationString2 = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
          locationString = locationString2
          print("Saved location to AppStorage: \(locationString)")
      }
      
      // Load location from AppStorage
      private func loadSavedLocation() {
          let savedString = locationString
          let components = savedString.split(separator: ",").map { Double($0) }
          if let lat = components.first, let lon = components.last {
              userLocation = CLLocation(latitude: lat ?? 0.0, longitude: lon ?? 00.0)
              print("Loaded saved location: \(lat), \(lon)")
          }
      }
}
