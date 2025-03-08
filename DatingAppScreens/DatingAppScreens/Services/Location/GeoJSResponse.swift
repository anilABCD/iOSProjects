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
struct GeoJSResponse: Codable {
    let city: String?
    let region: String?
    let country: String?
    let latitude: String?
    let longitude: String?
}

class GeoLocationViewModel: ObservableObject {
    @Published var location: GeoJSResponse?

    func fetchLocation() {
        let urlString = "https://get.geojs.io/v1/ip/geo.json"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(GeoJSResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.location = decodedData
                    }
                } catch {
                    print("❌ JSON Decoding Error: \(error)")
                }
            }
        }.resume()
    }
}










