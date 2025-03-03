//
//  ToastManager.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 03/03/25.
//


import SwiftUI

class ToastManager: ObservableObject {
    @Published var message: String = ""
    @Published var isShowing: Bool = false

    func showToast(message: String, duration: TimeInterval = 2) {
        self.message = message
        self.isShowing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.isShowing = false
        }
    }
}
