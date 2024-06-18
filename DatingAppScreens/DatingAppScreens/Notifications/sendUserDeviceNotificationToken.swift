//
//  sendUserDeviceNotificationToken.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 18/06/24.
//

import Foundation

func sendDeviceTokenToServer(_ token: String , userId:String) async throws {
    guard let url = URL(string: "\(Constants.localhost)/notifications/register-device-token") else {
        throw URLError(.badURL)
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = ["token": token, "userId": userId]
    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

    do {
        let (data, response) = try await URLSession.shared.data(for: request)

        // Handle server response
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print("Device token successfully sent to server.")
        } else {
            print("Failed to send device token to server.")
        }
    } catch {
        print("Error sending token to server: \(error)")
        throw error
    }
}

