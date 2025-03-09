//
//  Print.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 08/03/25.
//
 


let debug = true  // Set to false to disable logging

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    if debug {
        Swift.print(items.map { "\($0)" }.joined(separator: separator), terminator: terminator)
    }
}


