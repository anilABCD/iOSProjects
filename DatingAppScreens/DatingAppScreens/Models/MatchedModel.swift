
import Foundation

struct MatchedEncodable : Encodable {
    
  
}

struct MatchedResponse : Identifiable, Decodable {
   
    var objectId : ObjectId;
    
    var id: String {
        return objectId.value
    }
    
    let userOne: Profile?
    let userTwo: Profile?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case objectId = "_id"
        case userOne = "user1_id"
        case userTwo = "user2_id"
        case status
    }

}
