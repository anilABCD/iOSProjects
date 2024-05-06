//
//  Person.swift
//  SwfitUINavigationApp
//
//  Created by Anil Kumar Potlapally on 06/05/24.
//

import Foundation

 
struct Person : Identifiable , Hashable {
    
   let id = UUID()

    let name : String
    let age : Int
}

extension Person {
    
    static let examples : [Person] = [
        .init(name:"Anil" , age: 20 ) ,
        .init(name:"Venkatesh" , age: 25 )
    ]
}
