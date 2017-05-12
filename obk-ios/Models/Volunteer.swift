import Argo
import Curry
import Foundation
import Runes

public struct Volunteer {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let mobileNumber: String
    let landlineNumber: String?
    let dateOfBirth: String
    let wwccn: String?
    let subNewsletter: Bool
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "mobile_number": mobileNumber,
            "landline_number": landlineNumber ?? "",
            "dob": dateOfBirth,
            "wwccn": wwccn ?? "",
            "sub_newsletter": subNewsletter
        ]
    }
}

extension Volunteer: Decodable {
    public static func decode(_ j: JSON) -> Decoded<Volunteer> {
        let create = curry(Volunteer.init)
        let tmp = create
            <^> j <|  "id"
            <*> j <|  "first_name"
            <*> j <|  "last_name"
            <*> j <|  "email"
            <*> j <|  "mobile_number"
            <*> j <|? "landline_number"
        return tmp <*> j <| "dob"
            <*> j <|?  "wwccn"
            <*> j <|  "sub_newsletter"
    }
}
