import Foundation

// Request body model
struct SignUpData: Codable {
    let name: String
    let email: String
    let password: String
    let passwordConfirm: String
    let technology: [String]
    let hobbies:[String]?
}

// Request body model
struct SignInData: Codable {
    let email: String
    let password: String
}

struct SignInWithSocialLoginData : Codable {
    let token: String
}

// Response model
struct AuthResponse: Decodable {

    let status : String? ;
    let error : String?;
    let token: String?;
    let details : String?;
    let data : UserData?;
    let message : String?;

    // You can add more properties if needed
    
    struct UserData : Decodable {
        
        let user : User?
    }

    struct User : Decodable {
        
        let objectId : ObjectId
        
        // Computed property for Identifiable protocol
        var id: String {
            return objectId.value
        }
        
        let name : String?
        let email : String?
        let photo : String?
        let technologies : String?
        let hobbies: String?
        let dob : String?
        let drinking : String?
        let smoking : String?
        
        let bio : String?
        let jobRole : String?
        
        enum CodingKeys: String, CodingKey {
               case objectId = "_id"
               case name
            case email
            case photo
            case technologies
            case hobbies
            case dob
            case drinking
            case smoking
            case bio
            case jobRole
               // Other fields...
           }
        
    }

}


struct MatchesFilter : Codable {
    let technologies : String
    let minAge : String
    let maxAge : String
    let excludeProfileIds : String
}
