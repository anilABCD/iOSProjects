//
//  DateUtilities.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 05/01/25.
//

import Foundation

// Function to get the current UTC time in string format
func getCurrentUTCTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"  // ISO 8601 format for UTC
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")  // Set to UTC time zone
    return dateFormatter.string(from: Date())  // Use Date.now() which is equivalent to Date()
}

