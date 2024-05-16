import Foundation

// Request body model
struct SignUpData: Codable {
    let name: String
    let email: String
    let password: String
    let passwordConfirm: String
    let technology: [String]
}

// Response model
struct AuthResponse: Codable {
    let token: String
    // You can add more properties if needed
}
