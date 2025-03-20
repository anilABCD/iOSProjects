//
//  Keychainaccess.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 17/03/25.
//

//
//  Keychain.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 17/03/25.
//


import KeychainAccess

let keychain = Keychain(service: "com.dating.app.screens.DatingAppScreens").accessibility(.whenPasscodeSetThisDeviceOnly) // Ensures deletion on app uninstall

// Storing JWT
func saveToken(_ token: String) {
    do {
        try keychain.set(token, key: "jwtToken")
    } catch {
        print("Error saving token: \(error)")
    }
}

// Retrieving JWT
func getToken() -> String? {
    return try? keychain.get("jwtToken")
}

// Deleting JWT
func deleteToken() {
    try? keychain.remove("jwtToken")
}
