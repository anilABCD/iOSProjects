//
//  Date.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/03/25.
//

import SwiftUI


struct Utils {
    struct UDate {
        static func getAge ( dob : Date?) -> String {
            guard let dob = dob else { return "N/A" } // Handle nil case
                       let calendar = Calendar.current
                       let birthYear = calendar.component(.year, from: dob)
                       let currentYear = calendar.component(.year, from: Date())
                       return "\(max(0, currentYear - birthYear))"
        }
    }
}
