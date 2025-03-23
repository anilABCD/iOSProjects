//
//  GeoJSResponse.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 08/03/25.
//


//
//  GeoIO.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 08/03/25.
//

//https://get.geojs.io/v1/ip/geo/{ip address}.json

import SwiftUI

// Model to decode the GeoJS response
struct GeoJSResponse: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    
    let city: String?
    let region: String?
    let country: String?
    let latitude: String?
    let longitude: String?
    
    // Exclude `id` from coding keys so it's not expected in JSON
      private enum CodingKeys: String, CodingKey {
          case city, region, country, latitude, longitude
      }
    
    // Custom Equatable conformance
    static func == (lhs: GeoJSResponse, rhs: GeoJSResponse) -> Bool {
        return lhs.city == rhs.city &&
               lhs.region == rhs.region &&
               lhs.country == rhs.country &&
               lhs.latitude == rhs.latitude &&
               lhs.longitude == rhs.longitude
    }
}

class GeoLocationViewModel: ObservableObject {
    @Published var location: GeoJSResponse?
    @AppStorage("location")  var locationString : String = ""
    func fetchLocation() async {
        
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
        
        let urlString = "https://get.geojs.io/v1/ip/geo.json"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    print("geo js location data 1 \(data)")
                    let decodedData = try JSONDecoder().decode(GeoJSResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.location = decodedData
                        UserDefaults.standard.set(now, forKey: "lastUpdateTime")
                        print("geo js location data 2\(self.location)")
                    }
                } catch {
                    print("❌ JSON Decoding Error: \(error)")
                }
            }
        }.resume()
    }
}










