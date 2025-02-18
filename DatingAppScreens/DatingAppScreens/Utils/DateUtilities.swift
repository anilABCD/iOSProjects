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


func formattedDateddMMMyyy ( dateString : String? ) -> String {
    
    
    let resultDate : Date?
    
    if let timestampString = dateString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
        
        if let timestampDate = dateFormatter.date(from: timestampString) {
            resultDate = timestampDate
        } else if let timestampDouble = Double(timestampString) {
            resultDate = Date(timeIntervalSince1970: timestampDouble)
        } else {
            
            resultDate = nil
        }
    } else {
        resultDate = nil // If timestamp is not provided, set it to nil
    }
    
    
    if let date = resultDate {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy" // Example: 18 Feb 2025
        return formatter.string(from: date)
    }
    
    
    return ""
        
}


