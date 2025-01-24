//
//  ClosingKeyboard.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 24/01/25.
//

import SwiftUI

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
