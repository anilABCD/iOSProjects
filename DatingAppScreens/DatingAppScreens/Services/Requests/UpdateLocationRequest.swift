//
//  UpdateLocationRequest.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 22/03/25.
//


import Foundation

struct UpdateLocationRequest: Codable {
    let longitude: Double
    let latitude: Double
}

struct Success : Codable , Identifiable {
    var id : UUID = UUID()
    var status : String
    
    enum CodingKeys: CodingKey {

        case status
    }
}

class UserService {
    static let shared = UserService()
    private let baseURL = Constants.localhost
    
    func updateUserLocation( accessToken : String , longitude: Double, latitude: Double, completion: @escaping (Result<Void, Error>) -> Void) async {
        guard let url = URL(string: "\(baseURL)/profiles/location") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = UpdateLocationRequest(longitude: longitude, latitude: latitude)
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        
        do {
            
            let urlRequest =  try createURLRequest(method : "POST" , baseURL: "\(baseURL)/profiles/location", accessToken: accessToken, data: body, parameters: nil)
           
            let response: Success = try await fetchData(from: urlRequest)
            
            print ("location successfully updated")
            
            completion(.success(()))
            
        }
        catch {
            
            print ("location failed updated \(error.localizedDescription) ")
            
            completion(.failure(error))
        }
        
//        URLSession.shared.dataTask(with: request) { _, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                completion(.failure(NSError(domain: "Server Error", code: 500, userInfo: nil)))
//                return
//            }
//            
//            completion(.success(()))
//        }.resume()
      
        
    }
}
