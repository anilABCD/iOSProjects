//
//  ContentView.swift
//  Apple Sign In
//
//  Created by Anil Kumar Potlapally on 09/05/24.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: View {
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                // Configure your request for the user's Apple ID data
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                // Handle the result of the Apple ID request
                switch result {
                case .success(let authorization):
                    handleAppleIDAuthorization(authorization)
                case .failure(let error):
                    print("Error during Apple ID authorization: \(error)")
                }
            }
        )
        .signInWithAppleButtonStyle(.black) // Choose a style (black, white, or whiteOutline)
        .frame(width: 200, height: 50) // Optional sizing
    }

    private func handleAppleIDAuthorization(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Extract the user's Apple ID information
            let userIdentifier = appleIDCredential.user
            let userEmail = appleIDCredential.email
            let userFullName = appleIDCredential.fullName

            // Process the user data
            print("User ID: \(userIdentifier)")
            if let email = userEmail {
                print("Email: \(email)")
            }
            if let fullName = userFullName {
                print("Full name: \(fullName.givenName ?? "") \(fullName.familyName ?? "")")
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Sign in with Apple Demo")
            SignInWithAppleView()
        }
    }
}

#Preview {
    ContentView()
}
