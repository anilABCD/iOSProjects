//
//  Utils.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 12/06/24.
//

import Foundation


func formattedDate(date: Date) -> String {

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    return dateFormatter.string(from: date)
    
}

