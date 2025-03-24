
import Foundation

struct LikesEncodable : Encodable {
    
  
}

struct LikesResponse : Identifiable, Decodable {
   
//    var objectId : ObjectId;
    
    var id : String
    
    let userFrom: Profile?
    let userToId: String?
    let action: String?

    enum CodingKeys: String, CodingKey {
        case id
//        case objectId = "_id"
        case userFrom = "user_from_id"
        case userToId = "user_to_id"
        case action
    }

}

 

