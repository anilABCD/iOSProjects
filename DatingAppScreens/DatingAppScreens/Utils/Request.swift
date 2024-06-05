//
//  Request.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 04/06/24.
//
import SwiftUI
import Foundation


// Async function to perform the network request with generic response type
func createURLRequest<T: Encodable>(baseURL: String, accessToken : String , data : T? , parameters: [String: String]? ) throws -> URLRequest {
  var urlComponents = URLComponents(string: baseURL)
    if let parameters = parameters {
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
  guard let url = urlComponents?.url else {
    throw StringError(message: "Failed to create URL")
  }
  var request = URLRequest(url: url)
  request.httpMethod = "GET" // Change this to the appropriate HTTP method for your request
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    if let data = data {
        if let encodedData = try? JSONEncoder().encode(data.self) { // Explicitly use T.self for encoding
            request.httpBody = encodedData
        }
  }
  return request
}



// Async function to perform the network request with generic response type
func fetchData<T: Decodable>(from request: URLRequest) async throws -> T {
  let (data, response) = try await URLSession.shared.data(for: request)

  guard let httpResponse = response as? HTTPURLResponse else {
    throw StringError(message: "Invalid response received")
  }

  if httpResponse.statusCode >= 400 {
    throw StringError(message: "\(httpResponse.statusCode )")
  }

  let decodedResponse = try JSONDecoder().decode(T.self, from: data)
  return decodedResponse
}





