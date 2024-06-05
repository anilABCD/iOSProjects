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
    let status : String? ;
    let error : String?;
    let token: String?;
    let details : String?;
    let data : UserData?;
    let message : String?;

    // You can add more properties if needed
    
    struct UserData : Codable {
        
        let user : User?
    }

    struct User : Codable {
        
        let name : String?
        let email : String?
        let photo : String?
        let technologies : String?
        
    }

}


struct MatchesFilter : Codable {
    let technologies : String?
    let minExperience : Int?
    let maxExperience : Int?
}
