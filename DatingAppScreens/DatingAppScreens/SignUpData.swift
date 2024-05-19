import Foundation

// Request body model
struct SignUpData: Codable {
    let name: String
    let email: String
    let password: String
    let passwordConfirm: String
    let technology: [String]
}

// Request body model
struct SignInData: Codable {
    let email: String
    let password: String
}

struct SignInWithGoogleData : Codable {
    let token: String
}

// Response model
struct AuthResponse: Codable {
    
    let error : String?;
    let token: String?;
    let details : String?;
    // You can add more properties if needed
}
